#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# perform ls command on mobile phone directory mounted on MTP
# See alse mnt-phone.sh ls-phone.sh scan-phone.sh random-ringtone.sh podcasts-to-phone.sh metadata-cleanup-phone.sh

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

#MTP=/data/me/mtp
#phone=$MTP/Phone

#set -x

if [ -e "$phone" ]; then
	echo "$MTP"
	ls -al "$MTP"

	if ([ ! -z "$RANDOM_RINGS" ] && [ -e "$RANDOM_RINGS" ]); then
		echo " "
		echo RANDOM_RINGS is defined:
		ls -loS $RINGTONE $RANDOM_RINGS/
	fi

	if ([ ! -z "$PODCASTS_TO" ] && [ -e "$PODCASTS_TO" ]); then
		echo " "
		echo PODCASTS_TO is defined:
		ls -loS $PODCASTS_TO/_NEW $PODCASTS_TO/_REMOVE $PODCASTS_TO
	fi

	if ([ ! -z "$PRIVACY_SAFE" ] && [ -e "$PRIVACY_SAFE" ]); then
		echo " "
		echo PRIVACY_SAFE is defined:
		ls -loS $PRIVACY_SAFE
	fi

	if ([ ! -z "$PRIVACY_SAFE_DONE" ] && [ -e "$PRIVACY_SAFE_DONE" ]); then
		echo " "
		echo PRIVACY_SAFE_DONE is defined:
		ls -loS $PRIVACY_SAFE_DONE
	fi
else
	echo `ls "$phone"` use mnt-phone.sh $CONFIG to mount your phone. > /dev/stderr
	exit 2
fi
