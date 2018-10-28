#!/bin/bash
# cross-platform play a sound file as an alarm now, or at a specified time
# alarm.sh "2017-01-02 10:01" [sound-file]

WHEN=$1
SOUND=${2:-$HOME/bin/sounds/chime.wav}
POLL=5
WAIT=1

NOW=`datestamp.sh | cut -c 1-16`
if [ ! -z "$WHEN" ]; then
	echo $NOW: alarm will go off at $WHEN
	while [ "$NOW" != "$WHEN" ]; do
		sleep $POLL
		NOW=`datestamp.sh | cut -c 1-16`
	done
fi

echo $NOW: playing alarm file "$SOUND"
while true; do
	sound-play.sh "$SOUND"

	sleep $WAIT
done
