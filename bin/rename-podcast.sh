#!/bin/bash
# label all original/NN-title.mp3 files and output to current directory
FILE="$1"
BASE=`basename $FILE`

if [ -z $FILE ]; then
	for f in *.mp3; do echo $f; $0 $f; done
else
	TO="output/$BASE"

	# Maintain list of tracks so track number can be worked out so long as you process them in proper order
	touch "$TO"
	find output -type f | sort | grep 'mp3' | perl -pne '$_ = "$.: $_"' > tracks.lst
	grep $BASE tracks.lst
	TRK=`grep $BASE tracks.lst | perl -pne 's{\A(\d+):.+}{$1}xms'`

    # OPAR-3-Concept-Formation-01-p73-74.mp3
	CHAP=`echo $FILE | perl -pne '$_ = $1 if m{OPAR-(\d+)}xms; $_ = length($_) == 1 ? "0$_\n": "$_\n"'`
	DESC=`echo $FILE | perl -pne '$_ = "$1\n" if m{OPAR-\d+-(.+)-\d+-p\d+-\d+}xms; s{-}{ }xmsg'`
	PAGES=`echo $FILE | perl -pne '$_ = "$1\n" if m{OPAR-\d+-.+-\d+-p(\d+-\d+)}xms'`

	SONG="O.P.A.R. CH$CHAP $DESC P$PAGES"
	ALBUM="Objectivism: Philosophy of Ayn Rand"
	ARTIST="Dr. Leonard Peikoff"
	SPOKEN=101
	YEAR=2010

echo TRK=$TRK
echo SONG=$SONG

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
		--TCON "Spoken Word" \
		--TYER $YEAR \
		--TLAN "English" \
		"$TO"

	id3v2 --list "$TO"
fi
exit
id3v1 tag info for output/Chapter-03-Concept-Formation/OPAR-3-Concept-Formation-01-p73-74.mp3:
Title  : O.P.A.R. CH03 Concept Formatio  Artist: Dr. Leonard Peikoff
Album  : Objectivism: Philosophy of Ayn  Year: 2010, Genre: Unknown (255)
Comment:                                 Track: 15
id3v2 tag info for output/Chapter-03-Concept-Formation/OPAR-3-Concept-Formation-01-p73-74.mp3:
TPE1 (Lead performer(s)/Soloist(s)): Dr. Leonard Peikoff
TALB (Album/Movie/Show title): Objectivism: Philosophy of Ayn Rand
TPE2 (Band/orchestra/accompaniment): Dr. Leonard Peikoff
TIT2 (Title/songname/content description): O.P.A.R. CH03 Concept Formation P73-74
TRCK (Track number/Position in set): 15
TYER (Year): 2010
TDRC ():  frame
TCON (Content type): Spoken Word (255)
APIC (Attached picture): ()[, 3]: image/jpeg, 14311 bytes
