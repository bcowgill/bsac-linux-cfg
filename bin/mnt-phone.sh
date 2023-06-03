#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# unmount and remount the phone on MTP
# See alse mnt-phone.sh ls-phone.sh scan-phone.sh random-ringtone.sh podcasts-to-phone.sh metadata-cleanup-phone.sh

if [ "$1" == "--check" ]; then
	CHECK=1
	shift
else
	CHECK=
fi
CONFIG=${1:-~/.PHONE}
if [ "$2" == "--check" ]; then
	CHECK=1
fi

if [ -e "$CONFIG" ]; then
	source "$CONFIG"
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

#set -x

function is_mounted {
	local path
	path="$1"
	if [ -e "$path" ]; then
		FOUND=`find "$path" -maxdepth 2 | head | wc -l`
		if [ $FOUND -gt 5 ]; then
			echo $path: $FOUND files found, must be mounted.
			/bin/true
		else
			echo $path: $FOUND files found, might not be mounted.
			/bin/false
		fi
	else
		echo $path: is not mounted.
		/bin/false
	fi
}

function try_mount {
	if is_mounted "$MTP" ; then
		/bin/true
	else
		fusermount -u "$MTP" 2> /dev/null
		sleep 2
		jmtpfs "$MTP"
		sleep 2
		is_mounted "$MTP"
	fi
}

#MTP=/data/me/mtp

if try_mount || try_mount ; then
	if [ -z "$CHECK" ]; then
		exit 0
	else
		ls-phone.sh "$CONFIG"
	fi
else
	exit 1
fi
