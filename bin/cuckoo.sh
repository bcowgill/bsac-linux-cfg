#!/bin/bash
# Sound off a number of cuckoo chimes based on the current hour.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

CUCKOO=${1:-$HOME/bin/sounds/single-cuckoo-sound.mp3}
DELAY=0

hour=`date '+%I' | perl -pne 's{\A\s*0([0-9])}{$1}xms'`
#echo hour: $hour
while [ $hour != "0" ];
do
	if [ -f "$CUCKOO" ]; then
		sound-play.sh $CUCKOO
	else
		echo CUCKOO $hour!
	fi
	sleep $DELAY
	hour=$(($hour - 1))
done

exit
# crontab -e line to add to sound an hourly cuckoo clock
0 * * * * $HOME/bin/cuckoo.sh > /tmp/$LOGNAME/crontab-cuckoo.log  2>&1
