#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# moves photos from $XXX_FROM on the mobile phone to $XXX_PICS so that they can be archived.
# See alse mnt-phone.sh ls-phone.sh scan-phone.sh random-ringtone.sh podcasts-to-phone.sh metadata-cleanup-phone.sh

CONFIG=${1:-~/.PHONE}

if [ -e "$CONFIG" ]; then
	source "$CONFIG"
fi

# ~/.PHONE file contents:
#MTP=/data/me/mtp
#phone=$MTP/Phone
#XXX_FROM=$phone/DCIM/ZWhoah
#XXX_PICS=$HOME/d/Pics/xxx/saved

if [ -z "$XXX_FROM" ]; then
	echo XXX_FROM has not been configured. Please define it in ~/.PHONE file
	exit 20
fi

if [ -z "$XXX_PICS" ]; then
	echo XXX_PICS has not been configured. Please define it in ~/.PHONE file
	exit 20
fi

if [ ! -d $MTP ]; then
	echo MTP incorrectly configured. There is no $MTP directory. Please correctly define it in ~/.PHONE file
	exit 10
fi

if [ ! -d "$XXX_PICS" ]; then
	mkdir -p "$XXX_PICS"
fi

if [ ! -d "$XXX_PICS" ]; then
	exit 5
fi

echo "xxx-pics-move.sh $CONFIG [$XXX_FROM] to [$XXX_PICS]"

pushd "$XXX_PICS" > /dev/null

if mnt-phone.sh "$CONFIG" --check ; then
	/bin/true
else
	echo NOT OK was unable to mount the phone [$phone], is it connected and unlocked?
	exit 1
fi

function move_files {
	local from to ext
	from="$1"
	to="$2"
	ext="$3"
	if ls $from/*.$ext > /dev/null 2>&1 ; then
		echo OK moving .$ext files to metadata done dir
		mv $from/*.$ext "$to/"
	fi
}

if [ -d "$XXX_FROM" ]; then
	NEW="$XXX_PICS"
	REMOVE="$XXX_FROM"
	echo Moving pictures from phone at $REMOVE/ to hard disk at $NEW/
	echo `ls "$REMOVE" | wc -l` files waiting in $REMOVE
	echo `ls | wc -l` files already in $NEW
	move_files "$REMOVE" "$NEW" jpeg
	move_files "$REMOVE" "$NEW" JPEG
	move_files "$REMOVE" "$NEW" jpg
	move_files "$REMOVE" "$NEW" JPG
	move_files "$REMOVE" "$NEW" png
	move_files "$REMOVE" "$NEW" PNG
	echo `ls "$NEW" | wc -l` files now in $NEW
	if [ `ls "$REMOVE" | wc -l` == 0 ]; then
		echo OK, there are no files leftover in "$REMOVE/"
	else
		echo NOT OK, there are `ls "$REMOVE" | wc -l` files leftover in "$REMOVE/"
		ls "$REMOVE" | head
	fi
	echo TRY: cp "$NEW/phone-storage.png" "$REMOVE/"
	cp "$NEW/phone-storage.png" "$REMOVE/"
else
	echo No XXX pics dir $XXX_FROM found.
fi
