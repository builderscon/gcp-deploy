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
    data[clientkey]=$(cat config.json | jq -rjM .adminweb.clientkey | base64) \
    data[clientsecret]=$(cat config.json | jq -rjM .adminweb.clientsecret | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=googlemaps labels=$(jo name=googlemaps group=prd)) \
    data[apikey]=$(cat config.json | jq -rjM .googlemaps.apikey | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=github labels=$(jo name=github group=prd)) \
    data[id]=$(cat config.json | jq -rjM .github.id | base64) \
    data[secret]=$(cat config.json | jq -rjM .github.secret | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=github-adminweb labels=$(jo name=github-adminweb group=prd)) \
    data[id]=$(cat config.json | jq -rjM '."github-adminweb".id' | base64) \
    data[secret]=$(cat config.json | jq -rjM '."github-adminweb".secret' | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=facebook labels=$(jo name=facebook group=prd)) \
    data[id]=$(cat config.json | jq -rjM .facebook.id | base64) \
    data[secret]=$(cat config.json | jq -rjM .facebook.secret | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=twitter-adminweb labels=$(jo name=twitter-adminweb group=prd)) \
    data[consumer.key]=$(cat config.json | jq -rjM '.["twitter-adminweb"].consumer_key' | base64) \
    data[consumer.secret]=$(cat config.json | jq -rjM '.["twitter-adminweb"].consumer_secret' | base64) \
    | $APPLY

make_secret \
    metadata=$(jo name=flask labels=$(jo name=flask group=prd)) \
    data[secret]=$(cat config.json | jq -rjM .flask.secret | base64) \
    | $APPLY


