#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cross-platform play a sound file as an alarm now, or at a specified time
# also emits a system notification message.
# alarm.sh "2017-01-02 10:01" [sound-file]
# See also alarm-if.sh, quiet.sh, get-sound-level.sh, ls-sound.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

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
which mynotify.sh > /dev/null && mynotify.sh "alarm.sh $NOW" "Alarm for $NOW has arrived."
while true; do
	sound-play.sh "$SOUND"

	sleep $WAIT
done
