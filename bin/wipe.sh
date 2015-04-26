#!/bin/bash
# Wipe free space on device by writing random data to it 5 times

FILE=FILL-UP-DISK-DELETE.DAT

for PASS in 1 2 3 4 5;
do
	echo wiping pass $PASS `date`
	df -k
	cat /dev/urandom > $FILE || rm $FILE
done
echo wiped `date`
