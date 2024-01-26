#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

FILE=FILL-UP-DISK-DELETE.DAT
CWD=`pwd`
WHERE=${1:-$CWD}

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path

Wipe free space on a specific path or current directory by writing random data to it 5 times until it fills up.

path    Specify the device path to fill up. Defaults to current directory.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Creates a file FILL-UP-DISK-DELETE.DAT and sucks up all further disk space by writing to it.

See also wipe-phrase.sh lock.sh lockusb.sh
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

for PASS in 1 2 3 4 5;
do
	echo wiping pass $PASS `date` to "$WHERE/$FILE"
	if which pv > /dev/null ; then
		free=$( df "$WHERE" | awk '{print $4}' | tail -1 )
		dd if=/dev/urandom bs=1M count=999999999999 | pv -s "$free" > "$WHERE/$FILE"
		sync && rm "$WHERE/$FILE"
	else
		df -k "$WHERE"
		cat /dev/urandom > "$WHERE/$FILE" || (sync && rm "$WHERE/$FILE")
	fi
done
echo wiped `date`
