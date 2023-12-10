#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename ...

This will list the id3v2 genre along with the filename.
"
	exit
fi

while [ ! -z "$1" ]
do
	GENRE=`id3v2 --list "$1" | grep Genre: | perl -pne 's{\A.+Genre:\s+}{}xmsg'`
	GENRE=${GENRE:-nil}
	echo $GENRE: $1
	shift
done
