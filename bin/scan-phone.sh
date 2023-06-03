#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# scan-phone.sh find the files on mobile phone internal memory for use with shell-sync.pl
# also calls metadata-cleanup-phone.sh to moved stripped metadata files into a done dir.
# also calls random-ringtone.sh to change your ringtone.
# and copies podcasts from $PODCASTS_FROM to $PODCASTS_TO/_NEW removing any from $PODCASTS_TO/REMOVE
# See alse mnt-phone.sh ls-phone.sh scan-phone.sh random-ringtone.sh podcasts-to-phone.sh metadata-cleanup-phone.sh

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

#set -x

pushd $BACKUP_DIR > /dev/null

if mnt-phone.sh "$CONFIG" --check ; then
	/bin/true
else
	echo was unable to mount the phone [$phone], is it connected and unlocked?
	exit 1
fi

if [ ! -z "$PRIVACY_SAFE" ]; then
	metadata-cleanup-phone.sh "$CONFIG"
fi
if [ ! -z "$RINGTONES" ]; then
	random-ringtone.sh "$CONFIG"
fi
if [ ! -z "$PODCASTS_FROM" ]; then
	podcasts-to-phone.sh "$CONFIG"
fi

echo getting file list from phone...
find-ez.sh "$phone" > phone.lst
echo getting file list from local backup...
find-ez.sh "$backup" > phone-backup.lst
echo generating shell sync script go.sh for "$backup"
echo "# phone $backup shell sync script" > go.sh
shell-sync.pl "$phone" "$backup" phone.lst phone-backup.lst >> go.sh
chmod +x go.sh

echo created go.sh to update backup files from phone "$backup" contents.
