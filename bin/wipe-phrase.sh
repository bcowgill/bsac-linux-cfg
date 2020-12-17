#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Wipe free space on device by writing fixed data to it

FILE=FILL-UP-DISK-DELETE.DAT
CWD=`pwd`
WHERE=${1:-$CWD}
shift

for PASS in 1;
do
	echo wiping pass $PASS `date` to "$WHERE/$FILE" with phrase $*
	df -k $WHERE
	forever.pl $* > "$WHERE/$FILE" || (sync && rm "$WHERE/$FILE")
done
echo wiped `date` with phrase

