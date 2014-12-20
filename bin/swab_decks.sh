#!/bin/sh
TORRENTLIST=`transmission-remote --auth=user:pass --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=' ' --fields=1`
DEBUG=""
if [ -n "$1" ]; then
	DEBUG="1"
fi
 
for TORRENTID in $TORRENTLIST; do
	TORRENTID=`echo $TORRENTID | sed 's~\*~~'`
	DL_COMPLETED=`transmission-remote --auth=user:pass --torrent $TORRENTID --info | grep "Percent Done: 100%"`
	STATE_STOPPED=`transmission-remote --auth=user:pass --torrent $TORRENTID --info | grep "State: Stopped\|Finished\|Idle"`
	NAME=`transmission-remote --auth=user:pass --torrent $TORRENTID --info | grep "Name:" | sed -e 's~.*Name: ~~'`
	if [ "$DL_COMPLETED" != "" ] && [ "$STATE_STOPPED" ]; then
		REMOVE=`transmission-remote --auth=user:pass --torrent $TORRENTID --remove`
		if [ -n "`echo "$REMOVE" | grep "success"`" ]; then
			echo "Removed Torrent '$NAME' - $DL_COMPLETED"
		else
			echo "Failed to Removed Torrent '$NAME' - $DL_COMPLETED"
			echo "Error $REMOVE"
		fi
	fi
done
