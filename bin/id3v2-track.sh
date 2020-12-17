#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename ...

This will list the id3v2 track number along with the filename.
"
	exit
fi

while [ ! -z "$1" ]
do
	TRK=`id3v2 --list "$1" | grep Track: | perl -pne 's{\A.+Track:\s+}{}xmsg'`
	TRK=${TRK:-nil}
	echo $TRK: $1
	shift
done
