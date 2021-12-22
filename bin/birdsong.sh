#!/bin/bash

LAST=silence
SONG=$LAST
NORM=-3
PARAM=--no-show-progress

DIR=${1:-$HOME/d/Music/_Ringtones/birdsong}
DICE=${2:-50}
EXCLUDE=${3:-wood-pigeon}
EXT=mp3

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [directory] [delay_dice] [exclude]

This will play random sound files [.$EXT] from a given directory with a random delay between them.

directory   The directory to choose sound files from. default is "$DIR"
delay_dice  The number of standard dice to roll to determine the delay in seconds. default is $DICE
exclude     The regex pattern to use for excluding chosen sound files. default is "$EXCLUDE"
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

When choosing a sound file to play, it will force the next file to be different from the previous file.  It will also choose a file that is not currently being played by another instance of $cmd.

It will also filter out any file that matches "$EXCLUDE"

See also choose.pl, pswide.sh

"
	exit $code
}

if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

while [ ! -z "$SONG" ];
do
	#echo 1:$LAST 2:$SONG
	if [ "$LAST" == "$SONG" ]; then
		SONG=`ls -1 $DIR/*.$EXT | grep -vE "$EXCLUDE" | choose.pl`
		# pick another bird if the chosen one is currently singing.
		if pswide.sh | grep -v grep | grep $PARAM | grep "$SONG" 2> /dev/null > /dev/null; then
			echo $SONG is already being sung...
			SONG="$LAST"
		fi
	fi
	if [ "$LAST" != "$SONG" ]; then
		echo $SONG
		if which exiftool > /dev/null; then
			exiftool "$SONG" |grep -E 'Title|Duration'
		fi
		play $PARAM "$SONG"
		#play $PARAM --norm=$NORM "$SONG"
		LAST="$SONG"

		SLEEP=`DICE=$DICE perl -e 'sub r{return int(1+rand(6))}; for (1..$ENV{DICE}) {$d += r()}; print $d'`
		echo sleep $SLEEP
		sleep $SLEEP
	fi
done
