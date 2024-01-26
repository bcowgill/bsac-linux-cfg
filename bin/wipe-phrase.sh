#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

FILE=FILL-UP-DISK-DELETE.DAT
CWD=`pwd`

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path phrase...

Wipe free space on a specific path or current directory by writing a provided phrase until it fills up.

path    Specify the device path to fill up. Defaults to current directory.
phrase  The message to use to write to the free space until it is full.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Creates a file FILL-UP-DISK-DELETE.DAT and sucks up all further disk space by writing to it.

See also wipe.sh lock.sh lockusb.sh forever.pl
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

WHERE=${1:-$CWD}
shift

for PASS in 1;
do
	echo wiping pass $PASS `date` to "$WHERE/$FILE" with phrase $*
	df -k $WHERE
	forever.pl $* > "$WHERE/$FILE" || (sync && rm "$WHERE/$FILE")
done
echo wiped `date` with phrase
