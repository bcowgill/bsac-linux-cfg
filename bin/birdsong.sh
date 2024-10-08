#!/bin/bash

LAST=silence
SONG=$LAST
GAIN=-15
PARAM=--no-show-progress
FLAG=_DELETE_TO_SILENCE_THE_BIRDSONG_

DIR=$HOME/d/Music/_Ringtones/birdsong
EXCLUDE='wood-pigeon|collared-dove'
DICE=50
EXT=mp3

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--list] [directory] [exclude] [delay_dice]

This will play random sound files [.$EXT] from a given directory with a random delay between them.

directory   The directory to choose sound files from. default is "$DIR"
exclude     The regex pattern to use for excluding chosen sound files. default is "$EXCLUDE"
delay_dice  The number of standard dice to roll to determine the delay in seconds. default is $DICE
--list  Shows the birdsong files available to select from.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

When choosing a sound file to play, it will force the next file to be different from the previous file.  It will also choose a file that is not currently being played by another instance of $cmd.

It will also filter out any file that matches "$EXCLUDE"

You can stop all the $cmd instances by deleting the file $FLAG in the specified dir.

See also choose.pl, pswide.sh

Examples:

watch 'ps -ef | grep play | grep -v grep'

To watch for the song files which are currently being played.
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
if [ "$1" == "--list" ]; then
	shift
	LIST=1
fi

DIR=${1:-$DIR}
EXCLUDE=${2:-$EXCLUDE}
DICE=${3:-$DICE}

if [ ! -z $LIST ]; then
	ls -1 $DIR/*.$EXT | grep -vE "$EXCLUDE"
	exit 0
fi

echo You can silence all the birds with: rm $DIR/$FLAG
if [ ! -e "$DIR/$FLAG" ]; then
	touch "$DIR/$FLAG"
fi
while [ ! -z "$SONG" ];
do
	#echo 1:$LAST 2:$SONG
	if [ ! -e "$DIR/$FLAG" ]; then
		echo File $DIR/$FLAG is gone, exiting...
		exit 0;
	fi
	if [ "$LAST" == "$SONG" ]; then
		SONG=`ls -1 $DIR/*.$EXT | grep -vE "$EXCLUDE" | choose.pl`
		# pick another bird if the chosen one is currently singing.
		if pswide.sh | grep -v grep | grep -- $PARAM | grep "$SONG" 2> /dev/null > /dev/null; then
			echo $SONG is already being sung...
			SONG="$LAST"
		fi
	fi
	if [ "$LAST" != "$SONG" ]; then
		echo $SONG
		if which exiftool > /dev/null; then
			exiftool "$SONG" |grep -E 'Title|Duration'
		fi
		play $PARAM "$SONG" gain $GAIN
		LAST="$SONG"

		if [ ! -e "$DIR/$FLAG" ]; then
			echo File $DIR/$FLAG is gone, exiting...
			exit 0;
		fi

		SLEEP=`DICE=$DICE perl -e 'sub r{return int(1+rand(6))}; for (1..$ENV{DICE}) {$d += r()}; print $d'`
		echo sleep $SLEEP
		sleep $SLEEP
	fi
done
