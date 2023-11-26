#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Label a USB/SD card (up to 11 characters)

# To set this up, I configured /etc/mtools.conf drive letters as below:
# SD/USB drive
#drive s: file="/dev/sda1" # SD Card Slot
#drive u: file="/dev/sdb1" # USB slots
#drive v: file="/dev/sdc1"
#drive w: file="/dev/sdd1"
#drive x: file="/dev/sde1"

# Reference: https://linoxide.com/how-tos/howto-change-volume-label-on-usb-drives-in-linux/

CFG=/etc/mtools.conf
LOG=`mktemp`

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] device [label]

This will display or label a USB disk that is currently mounted.

device  Can be a device name or drive letter as configured in $CFG for mtools.
label   If supplied, the USB disk will be labeled with this.  Otherwise the current label will be shown.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This requires you to have correctly configured the mtools in $CFG you can use 'man 5 mtools' command for details.

See also usb-format.sh, mlabel

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

DRIVE=${1:-u:}
LABEL="$2"

if grep -E "^drive $DRIVE" $CFG > /dev/null; then
	echo $DRIVE
else
	WAS="$DRIVE"
	DRIVE=`grep drive $CFG | sed -re 's/#.+//g' | grep $DRIVE | awk '{ print($2) }'`
fi

if [ -z "$DRIVE" ]; then
	echo Did not find a USB device [$WAS] listed in $CFG cannot get drive letter.
	exit 10
fi

if [ -z "$LABEL" ]; then
	sudo mlabel -s $DRIVE
else
	sudo mlabel $DRIVE"$LABEL" 2>&1 | tee $LOG
	ERR=$?
	if grep 'too long' $LOG > /dev/null; then
		echo $LABEL
		echo '----------- Maximum label length'
	fi
	rm $LOG
fi
if [ 1 == $ERR ]; then
	echo If permission denied, you may want to try sudo $0 $1 $2
fi
