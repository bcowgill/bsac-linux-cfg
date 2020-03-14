#!/bin/bash
# Show exif or id3 v1 and v2 title information for file

if [ -z "$2" ]; then
	echo exiftool:
	exiftool "$1"
	echo id3info:
	id3info "$1"
	echo id3v2:
	id3v2 --list "$1"
	echo "------------------------------------------------------------"
	exit 0
fi

while [ ! -z "$1" ]; do
	$0 "$1"
	shift
done
