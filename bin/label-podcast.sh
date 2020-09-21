#!/bin/bash
# Touch up a podcast/song file track number, title and album

TRACK=$1
ALBUM="$2"
SONG="$3"
FILE="$4"

if [ -z "$FILE" ]; then
	echo "
$0 track \"album\" \"song\" filename

	You must provide a track number, album name, song title as well as file name.
"

	exit 1
fi

TITLE="$TRACK $SONG"

id3v2 --song "$TITLE" \
	--TIT2 "$TITLE" \
	--comment "$TITLE" \
	--album "$ALBUM" \
	--TALB "$ALBUM" \
	--TIT1 "$ALBUM" \
	--track $TRACK \
	"$FILE"

id3v2 --list "$FILE"

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
