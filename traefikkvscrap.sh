#!/usr/bin/env bash
while read p; do
	curl --request GET http://54.229.220.134:8555/v1/kv/traefik/$p 1> result.txt 2> /dev/null
	echo -n " $p = "
	cat result.txt | grep -o 'Value\"\:\".[^"]*' | cut -d '"' -f 3 | base64 --decode
	echo""
done <consulindex.txt
