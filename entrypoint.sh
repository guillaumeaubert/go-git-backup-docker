#!/bin/bash

if [ "$BACKUPS_TZ" = "" ] ; then BACKUPS_TZ="America/Los_Angeles" ; fi
cp /usr/share/zoneinfo/$BACKUPS_TZ /etc/localtime
echo $BACKUPS_TZ > /etc/timezone
echo "Date: `date`."

if [ "$BACKUPS_UID" != "" ] ; then
	if [ ! "$(id -u abc)" -eq "$BACKUPS_UID" ]; then
		echo "Switching uid from `id -u abc` to $BACKUPS_UID."
		usermod -o -u "$BACKUPS_UID" abc
	fi
else
	echo "BACKUPS_UID not specified, using default uid `id -u abc`."
fi

if [ "$BACKUPS_GID" != "" ] ; then
	if [ ! "$(id -g abc)" -eq "$BACKUPS_GID" ]; then
		echo "Switching gid from `id -g abc` to $BACKUPS_GID."
		groupmod -o -g "$BACKUPS_GID" abc
	fi
else
	echo "BACKUPS_GID not specified, using default gid `id -g abc`."
fi

chown -R abc:abc /data

if [ -f $FIRST_RUN_FLAG ]; then
	echo "First run, forcing backup now."
	/app/daily-backup-wrapper.sh
	rm $FIRST_RUN_FLAG
fi

echo "Starting cron."
exec crond -l 8 -f
