#!/bin/bash

CONFIGDIR=~/.config/resilio-sync
CONFIG=$CONFIGDIR/config.json
PIDFILE=$CONFIGDIR/sync.pid

CHROMIUM_VARIANTS=( chromium google-chrome microsoft-edge microsoft-edge-dev )
BROWSER=

rslsync_running() {
	# kill -0 checks for a process running, XXX: not listed on signal(7) nor kill(1) (???)
	[[ -f "$PIDFILE" ]] && kill -0 $(cat "$PIDFILE")
}

if ! rslsync_running ; then
	echo "Couldn't detect Resilio Sync running" >&2
	exit 75 # EX_TEMPFAIL
fi
	
for browser in "${CHROMIUM_VARIANTS[@]}"; do
	if type -p "$browser" ; then
		BROWSER="$browser"
		break
	fi
done >/dev/null

if [[ -z "$BROWSER" ]]; then
	echo "No known chromium variant detected." >&2
	exit 69 # EX_UNAVAILABLE
fi

webui_address() {

	local protocol='http'
	if grep -q '"force_https":\s*true' "$CONFIG" ; then
		protocol='https'
	fi

	local url=`sed '/"listen"/!d;s/.*"\([.:0-9][.:0-9]*\)".*$/\1/' "$CONFIG"`

	echo "$protocol://$url"
}

exec "$BROWSER" --app="$(webui_address)" 

