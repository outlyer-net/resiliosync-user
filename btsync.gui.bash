#!/bin/bash

CONFIGDIR=~/.config/resilio-sync
CONFIG=$CONFIGDIR/config.json
PIDFILE=$CONFIGDIR/sync.pid

CHROMIUM_VARIANTS=( chromium google-chrome microsoft-edge microsoft-edge-dev )
BROWSER=

parse_configured_pid() {
	# The configuration file may contain the path for the pid file
	# as pid_file
	local cfg_pid=`cat "$CONFIG" \
		| sed '/^[[:space:]]*\/\/.*$/d' \
		| jq -r .pid_file`
	if [ -n "$cfg_pid" ]; then
		PIDFILE="$cfg_pid"
	fi
}

rslsync_running() {
	# kill -0 checks for a process running, XXX: not listed on signal(7) nor kill(1) (???)
	#  found at <https://stackoverflow.com/questions/3043978/how-to-check-if-a-process-id-pid-exists>
	#  NOTE it will fail if you don't have permission to send the signal, however for
	#       this use case you should own the process
	#       Alternatively ps -p $PID could be used
	[[ -f "$PIDFILE" ]] && kill -0 $(cat "$PIDFILE")
}

if [ -f "$CONFIG" ]; then
	parse_configured_pid
fi

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

