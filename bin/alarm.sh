#!/bin/bash
# play a sound file as an alarm

CARD=1
SOUND=${1:-$HOME/bin/sounds/laser.wav}
echo playing alarm file "$SOUND"
while /bin/true; do
	aplay -D sysdefault:CARD=PCH "$SOUND"
	sleep 1
done
