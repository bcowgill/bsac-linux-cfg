#!/bin/bash

CFG=/etc/mtools.conf
VOL_MAX=12 # plus newline

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] device

This will allow you to format and label a USB disk that is currently plugged in.

device  The device name for the USB disk to format and label.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will ask for a volume name before unmounting and formatting the USB disk.

See also label-usb.sh, mtools
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

DEV="$1"

if [ -z "$DEV" ]; then
	df -h | grep -vE ' /(run|dev|sys|boot|$)'
	echo Which USB disk do you want to format? [Press Ctrl-C to stop now]
	read DEV
fi

DRIVE=`grep drive $CFG | sed -re 's/#.+//g' | grep /dev/sdb1 | awk '{ print($2) }'`

if [ -z "$DRIVE" ]; then
	echo Did not find a USB device listed in $CFG, cannot find drive letter.
	exit 10
fi

echo Confirm you want to format $DEV by providing a volume name: [Press Ctrl-C to stop now]
read VOLUME

if [ `echo "$VOLUME" | wc -m` -gt $VOL_MAX ]; then
	echo Volume name "$VOLUME" is too long.
	exit 20
fi

if [ ! -z "$VOLUME" ]; then
	echo Unmounting $DEV and formatting with label $DRIVE$VOLUME
	sudo umount $DEV
	sudo mkfs.vfat $DEV
	sudo mlabel $DRIVE"$VOLUME"
	sudo mlabel -s $DRIVE
fi
