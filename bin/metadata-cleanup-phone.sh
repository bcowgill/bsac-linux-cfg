#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# moves photos from $PRIVACY_SAFE to $PRIVACY_SAFE_DONE on the mobile phone so that the Metadata Remover App functions only on new files.
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

if [ -z "$PRIVACY_SAFE" ]; then
	echo PRIVACY_SAFE has not been configured. Please define it in ~/.PHONE file
	exit 20
fi

if [ -z "$PRIVACY_SAFE_DONE" ]; then
	echo PRIVACY_SAFE_DONE has not been configured. Please define it in ~/.PHONE file
	exit 20
fi

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

echo "metadata-cleanup-phone.sh $CONFIG [$PRIVACY_SAFE] to [$PRIVACY_SAFE_DONE]"

pushd $BACKUP_DIR > /dev/null

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

if [ ! -z "$PRIVACY_SAFE" ]; then
	if [ ! -z "$PRIVACY_SAFE_DONE" ]; then
		if [ -d "$PRIVACY_SAFE" ]; then
			NEW="$PRIVACY_SAFE_DONE"
			REMOVE="$PRIVACY_SAFE"
			mkdir -p "$NEW" 2> /dev/null
			if [ -d "$REMOVE" ]; then
				echo Moving photos, videos and sound files with removed metadata from phone at $REMOVE/ to $NEW/
				echo `ls "$REMOVE" | wc -l` files waiting in $REMOVE
				echo `ls "$NEW" | wc -l` files left in $NEW
				move_files "$REMOVE" "$NEW" jpeg
				move_files "$REMOVE" "$NEW" JPEG
				move_files "$REMOVE" "$NEW" jpg
				move_files "$REMOVE" "$NEW" JPG
				move_files "$REMOVE" "$NEW" png
				move_files "$REMOVE" "$NEW" PNG
				move_files "$REMOVE" "$NEW" mp3
				move_files "$REMOVE" "$NEW" MP3
				move_files "$REMOVE" "$NEW" mp4
				move_files "$REMOVE" "$NEW" MP4
				echo `ls "$NEW" | wc -l` files now in $NEW
				if [ `ls "$REMOVE" | wc -l` == 0 ]; then
					echo OK, there are no files leftover in "$REMOVE/"
				else
					echo NOT OK, there are `ls "$REMOVE" | wc -l` files leftover in "$REMOVE/"
					ls "$REMOVE" | head
				fi
				echo TRY: cp "$NEW/phone-storage.png" "$REMOVE/"
				cp "$NEW/phone-storage.png" "$REMOVE/"
			fi
		else
			echo No phone metadata removal dir $PRIVACY_SAFE found.
		fi
	fi
fi
