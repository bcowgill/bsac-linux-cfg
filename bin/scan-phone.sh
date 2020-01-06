#!/bin/bash
# scan-phone.sh find the files on mobile phone internal memory for use with shell-sync.pl

if [ -e ~/.PHONE ]; then
	source ~/.PHONE
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

echo getting file list from phone...
find-ez.sh $phone > phone.lst
echo getting file list from local backup...
find-ez.sh $backup > phone-backup.lst
echo generating shell sync script go.sh for $backup
echo "# phone $backup shell sync script" > go.sh
shell-sync.pl $phone $backup phone.lst phone-backup.lst >> go.sh
chmod +x go.sh

echo created go.sh to update backup files from phone $backup contents.
