#!/bin/bash
# Sound off a number of cuckoo chimes based on the current hour.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

# TODO select sound by name cuckoo.sh frog
# Nature sound effects: https://soundbible.com/search.php?q=cricket

WHERE=$HOME/bin/sounds/
CLUCK=single-cuckoo-sound.mp3

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

CUCKOO="${1:-$WHERE/$CLUCK}"
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
