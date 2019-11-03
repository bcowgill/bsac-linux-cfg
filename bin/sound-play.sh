#!/bin/bash
# play a sound file cross-platform

CARD=1
SOUND=${1:-$HOME/bin/sounds/laser.wav}
if which play > /dev/null; then
	play -q -- "$SOUND"
	exit 0
fi
if which afplay > /dev/null ; then
	afplay "$SOUND"
	exit 0
fi
if which aplay > /dev/null; then
	aplay -q -D sysdefault:CARD=PCH -- "$SOUND"
	exit 0
fi
# TODO tried to hear midi output, seems to play but don't hear anything.
#aplaymidi --port=14 --delay=1 /home/me/d/Music/WinMobHTCTyTn/Alouette.mid
echo NOT OK unable to find a sound player
exit 1
