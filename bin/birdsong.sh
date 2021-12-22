#!/bin/bash

DIR=${1:-$HOME/d/Music/_Ringtones/birdsong}
LAST=1
SONG=1
NORM=-3

while [ ! -z "$SONG" ];
do
	#echo 1:$LAST 2:$SONG
	if [ "$LAST" == "$SONG" ]; then
		SONG=`ls -1 $DIR/*.mp3 | grep -v pigeon | choose.pl`
		# pick another bird if the chosen one is currently singing.
		if pswide.sh | grep -v grep | grep "$SONG" 2> /dev/null; then
			SONG="$LAST"
		fi
	fi
	if [ "$LAST" != "$SONG" ]; then
		echo $SONG
		if which exiftool > /dev/null; then
			exiftool "$SONG" |grep -E 'Title|Duration'
		fi
		play --no-show-progress "$SONG"
		#play --norm=$NORM "$SONG"
		LAST="$SONG"

		SLEEP=`perl -e 'sub r{return int(1+rand(6))}; for (1..50) {$d += r()}; print $d'`
		echo sleep $SLEEP
		sleep $SLEEP
	fi
done
