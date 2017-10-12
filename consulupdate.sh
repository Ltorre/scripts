#!/usr/bin/env bash
while read p; do
	KEY=$(echo $p  | sed -e s/' '/''/g | cut -d '=' -f 1)
	VALUE=$(echo $p  | sed -e s/' '/''/g | cut -d '=' -f 2)
	curl --request PUT http://$1/v1/kv/traefik/$KEY $VALUE
	echo "$KEY = $VALUE set"
done <consulsave.txt
