#!/bin/bash
# label all original/NN-title.mp3 files and output to current directory
FILE="$1"

if [ -z $FILE ]; then
	for f in *.mp3; do echo $f; ./label-podcasts.sh $f; done
else
	TO="../$FILE"
	TRK=`echo $FILE | perl -pne '$_ = "$1\n" if m{(\d+)-}xms'`

	SONG="Wipro On Air - Podcast $TRK"
	ALBUM="Wipro Podcasts"
	ARTIST="Wipro Ltd"
	SPOKEN=101
	YEAR=2017

	cp "$FILE" "$TO"
	id3v2 \
		--song "$SONG" \
		--comment "$SONG" \
		--album "$ALBUM" \
		--year $YEAR \
		--genre $SPOKEN \
		--track $TRK \
		--artist "$ARTIST" \
		--COMM "$SONG" \
		--TALB "$ALBUM" \
		--TIT1 "$ALBUM" \
		--TIT2 "$SONG" \
		--TPE1 "$ARTIST" \
		--TPE2 "$ARTIST" \
		--OWNE "$ARTIST" \
		--TPUB "$ARTIST" \
		--TCOP "$ARTIST © $YEAR" \
		--TCON "Spoken" \
		--TYER $YEAR \
		--TLAN "English" \
		"$TO"

	id3v2 --list "$TO"
fi
