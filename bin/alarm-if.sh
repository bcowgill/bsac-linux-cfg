#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cross-platform play a sound file as an alarm after a given command succeeds.
# also emits a system notification message.
# alarm-if.sh check.sh [sound-file]
# See also alarm.sh, quiet.sh, get-sound-level.sh, ls-sound.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

CMD=$1
SOUND=${2:-$HOME/bin/sounds/kitten.ogg}
POLL=5
WAIT=1

if [ ! -z "$CMD" ]; then
	echo alarm will go off when $CMD succeeds
	$CMD
	while [ "$?" != "0" ]; do
		sleep $POLL
		$CMD
	done
fi

echo playing alarm file "$SOUND"
which mynotify.sh > /dev/null && mynotify.sh "alarm-if.sh $CMD" "Alarm $CMD has succeeded."

while true; do
	sound-play.sh "$SOUND"

	sleep $WAIT
done
