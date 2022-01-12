#!/bin/bash
# Sound off a number of cuckoo chimes based on the current hour.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

# TODO select sound by name cuckoo.sh frog
# TODO change sound used on Mac/Linux by day of week!
# date +%u
# Nature sound effects: https://soundbible.com/search.php?q=cricket

CLUCK=$HOME/bin/sounds/single-cuckoo-sound.mp3
TIGER="$HOME/bin/sounds/Tiger Growling-SoundBible.com-258880045.mp3"
if which sw_vers > /dev/null 2>&1 ; then
	# MACOS
	CLUCK="$TIGER"
fi

CUCKOO="${1:-$CLUCK}"
DELAY=0

hour=`date '+%I' | perl -pne 's{\A\s*0([0-9])}{$1}xms'`
#echo hour: $hour
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

exit
# crontab -e line to add to sound an hourly cuckoo clock
0 * * * * $HOME/bin/cuckoo.sh > /tmp/$LOGNAME/crontab-cuckoo.log  2>&1
