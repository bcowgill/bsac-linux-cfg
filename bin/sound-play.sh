#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] sound-file sleep repeat

This will play a sound file a number of times cross-platform.

sound-file  optional. The sound file to play. If omitted a laser sound is played.
repeat      optional. Number of times to repeat playing the sound. Default 1
sleep       optional. Number of seconds to sleep after playing the sound. Default 0.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh, filter-sounds.sh, find-sounds.sh, find-ez-sounds.sh, classify.sh

Example:

...
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

CARD=1
SOUND=${1:-$HOME/bin/sounds/laser.wav}
REPEAT=${2:-1}
SLEEP=${3:-0}

if [ $REPEAT -gt 1 ]; then
	# decrease REPEAT and call again...
	REPEAT=$(($REPEAT - 1))
	$0 "$SOUND" $REPEAT $SLEEP
fi

if which play > /dev/null; then
	play -q -- "$SOUND"
	sleep $SLEEP
	exit 0
fi
if which afplay > /dev/null ; then
	afplay "$SOUND"
	sleep $SLEEP
	exit 0
fi
if which aplay > /dev/null; then
	aplay -q -D sysdefault:CARD=PCH -- "$SOUND"
	sleep $SLEEP
	exit 0
fi
# TODO tried to hear midi output, seems to play but don't hear anything.
#aplaymidi --port=14 --delay=1 /home/me/d/Music/WinMobHTCTyTn/Alouette.mid
echo NOT OK unable to find a sound player
exit 1
