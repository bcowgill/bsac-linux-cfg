#!/bin/bash
# unmount and remount the phone on MTP

if [ -e ~/.PHONE ]; then
	source ~/.PHONE
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

#MTP=/data/me/mtp
fusermount -u $MTP 2> /dev/null
jmtpfs $MTP
ls-phone.sh
