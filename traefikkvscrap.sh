#!/usr/bin/env bash

curl --request GET http://$consulIP:$consulport/v1/kv/traefik/$1 1> result.txt 2> /dev/null
cat result.txt | grep -o 'Value\"\:\".[^"]*' | cut -d '"' -f 3 | base64 --decode
