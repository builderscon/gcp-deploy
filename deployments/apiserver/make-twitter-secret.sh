#!/bin/bash

set -e
PWD=$(cd $(dirname $0); pwd -P)

if [[ ! -e $PWD/twitter/twitter.json ]]; then
    echo "You must create a file $PWD/twitter/twitter.json with twitter tokens"
fi

exec jo -p \
    kind=Secret \
    apiVersion=v1 \
    type=Opaque \
    metadata=$(jo name=twitter labels=$(jo name=twitter group=secrets)) \
    data[access.token]=$(cat $PWD/twitter/twitter.json | jq -r -j -M '.["access_token"]' | base64)