#!/bin/bash
# scan-phone.sh find the files on mobile phone internal memory for use with shell-sync.pl

MTP=/data/me/mtp
phone=$MTP/Phone
backup=samsung-galaxy-note4-edge/phone

pushd ~/d/backup > /dev/null

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
echo generating shell sync script go.sh
shell-sync.pl $phone $backup phone.lst phone-backup.lst > go.sh
chmod +x go.sh

echo created go.sh to update backup files from phone contents.
