#!/bin/bash
# play a sound file as an alarm now, or at a specified time
# alarm.sh "2017-01-02 10:01" [sound-file]

CARD=1
WHEN=$1
SOUND=${2:-$HOME/bin/sounds/chime.wav}
POLL=5
WAIT=1

NOW=`date --rfc-3339=seconds | cut -c 1-16`
if [ ! -z "$WHEN" ]; then
	echo $NOW: alarm will go off at $WHEN
	while [ "$NOW" != "$WHEN" ]; do
		sleep $POLL
		NOW=`date --rfc-3339=seconds | cut -c 1-16`
	done
fi

echo $NOW: playing alarm file "$SOUND"
while /bin/true; do
	aplay -D sysdefault:CARD=PCH "$SOUND"
	sleep $WAIT
done
