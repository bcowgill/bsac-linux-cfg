#!/bin/bash
# Sound off a number of cuckoo chimes based on the current hour.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

# TODO select sound by name cuckoo.sh frog
# Nature sound effects: https://soundbible.com/search.php?q=cricket

WHERE=$HOME/bin/sounds/
CLUCK=single-cuckoo-sound.mp3
CUCKOO="$WHERE$CLUCK"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [sound-file] [offset] [chimes]

This will play a cuckoo clock sound to mark the current hour or any desired number of chimes.

sound-file  The sound file to play. default is $CUCKOO but varies by day of week and OS.
offset      Add or subtract this number from the current hour when calculating chimes.  You can use this to chime the hour a few minutes early or in a different time zone.
chimes      Specify the exact number of chimes to play ignoring the hour and offset completely.
--man       Shows help for this tool.
--help      Shows help for this tool.
-?          Shows help for this tool.

The specific sound file played varies by day of week for a little variety and Mac OS plays a different day's file than other OS's.

If the sound file does not exist then it will count down by printing the cuckoo chimes.

Example:

  Use a cron entry to sound every hour.

  0 * * * * \$HOME/bin/cuckoo.sh > /tmp/\$LOGNAME/crontab-cuckoo.log  2>&1

  Use a cron entry to sound the hour two minutes early.

  58 * * * * \$HOME/bin/cuckoo.sh "" 1 > /tmp/\$LOGNAME/crontab-cuckoo.log  2>&1
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

OFFSET=${2:-0}
CHIMES=$3

# Default sound varies by OS and day of week
DOW=`date +%u`
if which sw_vers > /dev/null 2>&1 ; then
	# MACOS
	DOW=$(($DOW-1))
fi
case $DOW in
	1) CLUCK="grandfather-clock-chime.mp3" ;;
	2) CLUCK="single-cuckoo-sound.mp3" ;;
	3) CLUCK="Cat-Meowing.mp3" ;;
	4) CLUCK="Cow-Moo.mp3" ;;
	5) CLUCK="Frog-Croaking.mp3" ;;
	6) CLUCK="Rooster-Crowing.mp3" ;;
	7) CLUCK="Doorbell.mp3" ;;
	*) CLUCK="Horse-Neigh-Sound.mp3" ;;
esac

CUCKOO="${1:-$WHERE$CLUCK}"
DELAY=0

if [ -z "$CHIMES" ]; then
	hour=`date '+%I' | OFFSET=$OFFSET perl -pne 's{\A\s*0([0-9])}{$1}xms; $_ = ($_ + $ENV{OFFSET}) % 12;'`
	if [ $hour == 0 ]; then
		hour=12
	fi
else
	hour=$CHIMES
fi
echo hour: $hour
while [ $hour != "0" ];
do
	if [ -f "$CUCKOO" ]; then
		sound-play.sh "$CUCKOO"
	else
		echo CUCKOO $hour!
	fi
	sleep $DELAY
	hour=$(($hour - 1))
done
