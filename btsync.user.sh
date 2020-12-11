#!/bin/sh

CONFIGDIR=~/.config/resilio-sync
CONFIG=$CONFIGDIR/config.json
PIDFILE=$CONFIGDIR/sync.pid
NAME='Resilio Sync'
BROWSER=xdg-open # may also use sensible-browser as abstraction

parse_configured_pid() {
	# The configuration file may contain the path for the pid file
	# as pid_file
	# Strip comments in case the uses writes some. Resilio Sync
	# seems to work fine with them but jq will not
	local cfg_pid=`cat "$CONFIG" \
		| sed '/^[[:space:]]*\/\/.*$/d' \
		| jq -r .pid_file`
	if [ -n "$cfg_pid" ]; then
		PIDFILE="$cfg_pid"
	fi
}

if [ ! -f "$CONFIG" ]; then
	echo "Writing configuration (by default to $CONFIG)" >&2
	/etc/resilio-sync/init_user_config.sh
else
	parse_configured_pid
fi

webui_address() {

	local protocol='http'
	if grep -q '"force_https":\s*true' "$CONFIG" ; then
		protocol='https'
	fi

	local url=`sed '/"listen"/!d;s/.*"\([.:0-9][.:0-9]*\)".*$/\1/' "$CONFIG"`

	echo "$protocol://$url"
}

#exec /usr/bin/rslsync --config "$CONFIG"

case "$1" in
	start|stop|status) action="$1" ;;
	restart)
		"$0" stop
		sleep 2s
		"$0" start
		exit $?
		;;
	webui)
		exec "$BROWSER" `webui_address`
		exit 2 # Shouldn't reach
		;;
	*)
		echo "Usage: $0 <start|stop|status|webui>" >&2
		exit 1
	;;
esac

# btsync creates $PIDFILE but doesn't remove it
/sbin/start-stop-daemon --$action --user "$USER" -v \
	--pidfile "$PIDFILE" --remove-pidfile \
	--exec /usr/bin/rslsync -- --config "$CONFIG"
RET=$?
if [ "$action" = 'status' ] ; then
	if [ $RET -eq 0 ]; then
		echo "$NAME running with pid `cat $PIDFILE`"
		echo -n "   Web UI listening on "
		echo `webui_address`
	else
		echo "$NAME not running"
	fi
fi

