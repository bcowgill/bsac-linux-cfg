#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# unmount and remount the phone on MTP

CONFIG=${1:-~/.PHONE}

if [ -e "$CONFIG" ]; then
	source "$CONFIG"
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi


#set -x

#MTP=/data/me/mtp
fusermount -u $MTP 2> /dev/null
jmtpfs $MTP
ls-phone.sh "$CONFIG"
