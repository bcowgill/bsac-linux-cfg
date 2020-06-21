#!/bin/bash
# Label a USB/SD card (up to 11 characters)

# To set this up, I configured /etc/mtools.conf drive letters as below:
# SD/USB drive
#drive s: file="/dev/sda1" # SD Card Slot
#drive u: file="/dev/sdb1" # USB slots
#drive v: file="/dev/sdc1"
#drive w: file="/dev/sdd1"
#drive x: file="/dev/sde1"

# Reference: https://linoxide.com/how-tos/howto-change-volume-label-on-usb-drives-in-linux/

DRIVE=${1:-u:}
LABEL=$2

echo $DRIVE
if [ -z "$2" ]; then
	mlabel -s $DRIVE
else
	mlabel $DRIVE"$LABEL"
fi
if [ 1 == $? ]; then
	echo If permission denied, you may want to try sudo $0 $1 $2
fi
