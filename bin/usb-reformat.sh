#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# MUSTDO https://help.ubuntu.com/community/mkusb - or see below command to restore a busted flash
# This didn't really work to revive the USB drive, what worked was to copy another 128M USB flast to the one that was broken.
# dmesg log indicated this when I plugged in the SCOT-128M drive:
# [40067.034853] sd 9:0:0:0: [sdb] 254720 512-byte logical blocks: (130 MB/124 MiB)
# sudo -i
# dd if=/dev/sdb bs=512 count=254720 | pv -s 128m > /dev/sdc
# After this, remove SCOT-128M USB and reinsert the target USB which also has the same label.  Used usb-label command to change the label to HEIDEN-128M and when mounted, shows the same directory contents as SCOT disk, so delete them all and it should be good.

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "0A
$cmd [--help|--man|-?] device

NOTE: THIS DOES NOT WORK. See the comments in the script itself for you to revive a USB flash disk
based on having another USB flash disk of the same capacity available to copy.

This will zero out the master block on the device supplied hopefully  restoring an unusable USB drive.

device  The /dev/sdZ device of a USB flash disk that is no longer readable by any OS.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

If flashing messess up the drive so that no OS can read it you can restore the drive with this program.
# Make sure the drive is unmounted (umount /dev/xxx), and run the following command as root, replacing xxx by your actual device path:

See also usb-format.sh label-usb.sh

Example:

MUSTDO test this on an old SD card do we use /dev/sdc or /dev/sdc1
...
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
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

if [ -z "$1" ]; then
	usage 1
fi
DEV="$1"

echo NOTE: THIS DOES NOT WORK. See the comments in the script itself for you to revive a USB flash disk based on having another USB flash disk of the same capacity available to copy.
exit 1

if mount | grep "$DEV" ; then
	>&2 echo Device $DEV is currently mounted, cannot reformat it. You need to unmount it first.
	exit 1
fi

# MUSTDO check device has or has not got the number in it depending on need
if echo $DEV | grep -E '[0-9]$' > /dev/null; then
	echo OK device has a partition number and will affect only one partition...
else
	echo OK device has no partition number and will affect the entire device...
fi

echo "About to re-write the master block on $DEV, press Ctrl-C or type yes to confirm."
read confirm
if [ "$confirm" == "yes" ]; then
	echo dd if=/dev/zero of=$DEV bs=512 count=1 conv=notrunc
fi

exit 0
