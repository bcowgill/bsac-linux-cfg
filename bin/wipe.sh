#!/bin/bash
# Wipe free space on device by writing random data to it 5 times

FILE=FILL-UP-DISK-DELETE.DAT
CWD=`pwd`
WHERE=${1:-$CWD}

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
done
echo wiped `date`
