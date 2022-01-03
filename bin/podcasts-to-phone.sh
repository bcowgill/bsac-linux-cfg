#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# copies podcasts from $PODCASTS_FROM to $PODCASTS_TO/_NEW removing any from $PODCASTS_TO/REMOVE

CONFIG=${1:-~/.PHONE}

if [ -e "$CONFIG" ]; then
	source "$CONFIG"
fi

# ~/.PHONE file contents:
#MTP=/data/me/mtp
#phone=$MTP/Phone
#backup=samsung-galaxy-note10/phone
#backup=samsung-galaxy-note4-edge/phone
#BACKUP_DIR=~/d/backup

if [ -z "$BACKUP_DIR" ]; then
	echo BACKUP_DIR has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$phone" ]; then
	echo phone has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$backup" ]; then
	echo backup has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ ! -d $BACKUP_DIR ]; then
	echo BACKUP_DIR incorrectly configured. There is no $BACKUP_DIR directory. Please correctly define it in ~/.PHONE file

	exit 10
fi

if [ ! -d $MTP ]; then
	echo MTP incorrectly configured. There is no $MTP directory. Please correctly define it in ~/.PHONE file
	exit 10
fi

pushd $BACKUP_DIR > /dev/null

if [ ! -d $phone ]; then
	echo will try to mount phone $phone
else
	echo will try to unmount and remount phone $phone
	fusermount -u $MTP
fi
jmtpfs $MTP

if [ ! -d $phone ]; then
	echo was unable to mount the phone, is it connected and unlocked?
	exit 1
fi

if [ ! -z "$PODCASTS_FROM" ]; then
	if [ ! -z "$PODCASTS_TO" ]; then
		if [ -d "$PODCASTS_FROM" ]; then
			NEW="$PODCASTS_TO/_NEW"
			REMOVE="$PODCASTS_TO/_REMOVE"
			if [ -d "$REMOVE" ]; then
				echo Remove podcasts from phone at $REMOVE/
				rm "$REMOVE/*.mp3"
			fi
			mkdir -p "$NEW" 2> /dev/null
			if [ -d "$NEW" ]; then
				echo Copy podcasts from $PODCASTS_FROM/ to $NEW/
				cp "$PODCASTS_FROM/*.mp3" "$NEW/"
			fi
		else
			echo No local podcasts dir $PODCASTS_FROM found.
		fi
	fi
fi
