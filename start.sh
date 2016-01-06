#!bin/bash

MPD_PID_FILE=/run/mpd/pid

start_mpd() {
	mpd --stderr --no-daemon 2>&1 | sed -u "s/^/[mpd] /"
}

start_client175() {
	cd /opt/client175
	su client175 -s/bin/sh -c'python server.py 2>&1 | sed -u "s/^/[client175] /"'
}

stop_mpd() {
	mpd --kill
}

stop_client175() {
	pkill -9 -u client175 python
}

finish() {
	stop_client175
	stop_mpd
}

OLD_AUDIO_GID="$(getent group audio | cut -d: -f3)"
AUDIO_GID="$(stat -c%g /dev/snd/pcmC1D0c)"

if [[ "$OLD_AUDIO_GID" != "$AUDIO_GID" ]]; then
	sed -ri "s@^(audio:x:)[0-9]+(.*)\$@\1$AUDIO_GID\2@" /etc/group
	sed -ri "s@^(([^:]+:){3})$OLD_AUDIO_GID(:.*)\$@\1$AUDIO_GID\3@" /etc/passwd
fi

[ ! -e /var/lib/mpd/playlists ] && mkdir /var/lib/mpd/playlists

trap 'finish;exit' INT TERM

(
	while true; do
		sleep 5
		start_client175
	done
) &

while true; do
	start_mpd
	stop_client175
	sleep 1
done