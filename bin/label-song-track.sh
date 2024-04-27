#!/bin/bash
# label the track number of all mp3 files taking it from the file name.
# assumes the file is in the form: 1-01 Hamilton - Alexander Hamilton.mp3
FILE="$1"

START=23

if [ -z "$FILE" ] ; then
	for f in *.mp3; do echo $f; ./label-song-track.sh "$f"; done
else
	TO="$FILE"
	TRK=`echo $FILE | perl -pne '$_ = $ENV{START} + $1 if m{-(\d+)}xms'`

	echo TRK=$TRK
	id3v2 \
		--track $TRK \
		"$TO"

	id3v2 --list "$TO"
fi
