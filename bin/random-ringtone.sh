#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# set ringtone randomly on mobile phone directory mounted on MTP

CONFIG=${1:-~/.PHONE}

if [ -e "$CONFIG" ]; then
	source "$CONFIG"
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$phone" ]; then
	echo phone has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$RINGTONES" ]; then
	echo RINGTONES has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$RINGTONE" ]; then
	echo RINGTONE has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$RANDOM_RINGS" ]; then
	echo RANDOM_RINGS has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

#MTP=/data/me/mtp
#phone=$MTP/Phone

echo "random-ringtones.sh $CONFIG from [$RANDOM_RINGS] to [$RINGTONE]";

if [ -e "$phone" ]; then
	echo "$MTP"
	ringtone=`ls "$RANDOM_RINGS" | choose.pl`
	if [ -z "$ringtone" ]; then
		echo NOT OK failed to choose a ringtone, are there any in "$RANDOM_RINGS"
		exit 3
	else
		echo OK setting "$ringtone" as "$RINGTONE"
		cp "$RANDOM_RINGS/$ringtone" "$RINGTONE"
	fi

else
	echo NOT OK `ls "$phone"` use mnt-phone.sh to mount your phone. > /dev/stderr
	exit 2
fi
