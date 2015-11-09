#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <container name>" >&2
	exit 1
fi

docker rmi mpd_client175
docker build --tag=mpd-client175 .
docker create --device=/dev/snd:/dev/snd -p 6600:6600 -p 8002:8080 -v /share/share/Music:/music -v /run/dbus:/run/dbus --name="$1" mpd-client175
