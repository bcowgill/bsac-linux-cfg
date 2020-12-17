#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

FILE="$1"

if [ -z "$FILE" ]; then
	echo "
usage: `basename $0` filename...

This will convert a Windows Media Audio file .WMA file into a .mp3 file using the avconv utility.
The .mp3 file will be written to the same directory as the .WMA file and the WMA file will be moved to a wma/ subdirectory.

"
	exit 1
fi

if [ -z "$2" ]; then

	D=`dirname "$FILE"`
	F=`basename "$FILE" .wma`
	F=`basename "$F" .WMA`

	set -e
	avconv -y -i "$FILE" -acodec libmp3lame -b:a 160k -ac 2 -ar 44100 "$D/$F.mp3"
	[ -d "$D/wma" ] || mkdir -p "$D/wma"
	mv "$FILE" "$D/wma/"

else
	for FILE in $*;
	do
		$0 "$FILE"
	done
fi
