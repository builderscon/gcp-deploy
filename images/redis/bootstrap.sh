#!/bin/sh
set -e

# Find which member of the Stateful Set this pod is running
# e.g. "redis-cluster-0" -> "0"
ORDINAL=$(echo -n $POD_NAME | rev | cut -d- -f1 |rev)

echo "Current pod $POD_NAME"

SEQ_BASE=$(set +e; expr $ORDINAL / $REDIS_GROUP_SIZE; set -e)
SEQ_MOD=$(set +e; expr $ORDINAL % $REDIS_GROUP_SIZE; set -e)
SLOT_BASE=$(expr 16384 / $(expr $REDIS_CLUSTER_NODES / $REDIS_GROUP_SIZE))

if [ "$SEQ_MOD" == "0" ]; then
    SEQ_START=$(set +e; expr $SLOT_BASE '*' $SEQ_BASE; set -e)
    SEQ_END=$(set +e; expr $(expr $SLOT_BASE '*' $(expr $SEQ_BASE + 1)) - 1; set -e)
    echo "Configuring slots $SEQ_START -> $SEQ_END"
    redis-cli cluster addslots $(seq $SEQ_START $SEQ_END)

    KUBE_TOKEN=$(cat</var/run/secrets/kubernetes.io/serviceaccount/token)
    PATCH=$(cat<<EOM)
[
  {
    "op": "add",
    "path": "/metadata/labels/redis-master",
    "value": "true"
  }
]
EOM

    curl -v -k --request PATCH \
        --data "$PATCH" \
        --header "Authorization: Bearer $KUBE_TOKEN" \
        -H "Content-Type:application/json-patch+json" \
        "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$POD_NAMESPACE/pods/$POD_NAME"
fi

if [ "$ORDINAL" == "0" ]; then
    exit 0
fi

SUBDOMAIN=$(grep pod.beta.kubernetes.io/subdomain /etc/podinfo/annotations | sed -e 's/.*="//' | sed -e 's/"$//')
MASTER_ZERO=$(echo -n $POD_NAME | sed -e 's/-[0-9]*$/-0/')
MASTER_ZERO_FULLNAME=$MASTER_ZERO.$SUBDOMAIN.$POD_NAMESPACE.svc.cluster.local
MASTER_ZERO_IP=$(host $MASTER_ZERO_FULLNAME | cut -d ' ' -f 4)

echo "Meeting at $MASTER_ZERO_IP:6379"
redis-cli cluster meet $MASTER_ZERO_IP 6379

if [ "$SEQ_MOD" == "0" ]; then
    exit 0
fi

sleep 1

# find our master. 
SEQ_MASTER=$(set +e; expr $SEQ_BASE '*' $REDIS_GROUP_SIZE; set -e)
MASTER=$(echo -n $POD_NAME | sed -e "s/-[0-9]*$/-$SEQ_MASTER/")
MASTER_FULLNAME=$MASTER.$SUBDOMAIN.$POD_NAMESPACE.svc.cluster.local
MASTER_IP=$(host $MASTER_FULLNAME | cut -d ' ' -f 4)
MASTER_ID=$(redis-cli cluster nodes | grep $MASTER_IP | cut -d ' ' -f 1)
echo "Replicating from Master $MASTER ($MASTER_ID)"
redis-cli cluster replicate $MASTER_ID