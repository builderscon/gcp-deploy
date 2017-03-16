#!/bin/bash

exec kubectl get ingress -o json "$@" | \
    jq -Mr '.metadata.annotations."ingress.kubernetes.io/backends"' | \
    jq -Mr 'keys[]' | \
    xargs -P 4 -n 1 -I {} gcloud compute http-health-checks update {} --check-interval 30 --timeout 30