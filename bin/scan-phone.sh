#!/bin/bash
# scan-phone.sh find the files on mobile phone internal memory for use with shell-sync.pl

MTP=/data/me/mtp
phone=$MTP/Phone

pushd ~/d/backup

if [ ! -d $phone ]; then
	echo will try to mount phone $phone
else
	echo will try to unmount and remount phone $phone
	fusermount -u $MTP
fi
jmtpfs $MTP

if [ ! -d $phone ]; then
	echo was unable to mount the phone, is it connected?
	exit 1
fi

find-ez.sh $phone > phone.lst
find-ez.sh samsung-galaxy-note4-edge/phone > phone-backup.lst
shell-sync.pl $phone samsung-galaxy-note4-edge/phone phone.lst phone-backup.lst > go.shP

echo created go.sh to update backup files from phone contents.
