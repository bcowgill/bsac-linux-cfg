#!/bin/bash
# find unplayable files and convert them to playable formats

FIND=find-unplayable.sh
HAS=has-playable.pl

if [ -x ./find-unplayable.sh ]; then
	FIND=./find-unplayable.sh
	echo Finding unplayable files with custom script: $FIND
else
	echo Finding unplayable files with: $FIND
	echo "(create ./$FIND to customize files to ignore)"
fi
$FIND | $HAS --not

TOTAL=`$FIND | $HAS --not | wc -l`

while [ 0 != $TOTAL ]
do
	echo
	echo $TOTAL unplayable sound files remain.
	file=`$FIND | $HAS --not | head -1`
	echo "$file"
	echo Press ENTER to manually convert this file to .mp3, .wav, .ogg with audacity...
	read wait
	audacity "$file" 2> /dev/null
	TOTAL=`$FIND | $HAS --not | wc -l`
done
echo No unplayable sound files found.
