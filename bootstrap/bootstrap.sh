#!/bin/bash

set -e

APPLY="kubectl apply -f -"
make_secret() {
    jo -p \
        kind=Secret \
        apiVersion=v1 $@
}

make_secret \
    metadata=$(jo name=adminweb labels=$(jo name=adminweb group=prd)) \
    data[clientkey]=$(cat config.json | jq -rM .adminweb.clientkey | base64) \
    data[clientsecret]=$(cat config.json | jq -rM .adminweb.clientsecret | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=googlemaps labels=$(jo name=googlemaps group=prd)) \
    data[apikey]=$(cat config.json | jq -rM .googlemaps.apikey | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=github labels=$(jo name=github group=prd)) \
    data[id]=$(cat config.json | jq -rM .github.id | base64) \
    data[secret]=$(cat config.json | jq -rM .github.secret | base64) \
    | $APPLY

