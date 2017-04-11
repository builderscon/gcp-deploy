#!/bin/bash

set -e
PWD=$(cd $(dirname $0); pwd -P)

if [[ ! -e $PWD/mailgun/mailgun.json ]]; then
    echo "You must create a file $PWD/mailgun/mailgun.json with secret_api_key/public_api_key fields"
fi

exec jo -p \
    kind=Secret \
    apiVersion=v1 \
    type=Opaque \
    metadata=$(jo name=mailgun labels=$(jo name=mailgun group=secrets)) \
    data[default.sender]=$(cat $PWD/mailgun/mailgun.json | jq -r -j -M '.["default_sender"]' | base64) \
    data[domain]=$(cat $PWD/mailgun/mailgun.json | jq -r -j -M '.["domain"]' | base64) \
    data[secret.api.key]=$(cat $PWD/mailgun/mailgun.json | jq -r -j -M '.["secret_api_key"]' | base64) \
    data[public.api.key]=$(cat $PWD/mailgun/mailgun.json | jq -r -j -M '.["public_api_key"]' | base64)