#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [sound-file] [--help|--man|-?]

A cross-platform command to play a sound file as an alarm now, or at a specified time.

sound-file  a specific file to play as an alarm instead of the default one.
--man       Shows help for this tool.
--help      Shows help for this tool.
-?          Shows help for this tool.

Also emits a system notification message.

See also alarm-if.sh, mynotify.sh, watcher.sh, check-ezbackup-finished.sh, quiet.sh, get-sound-level.sh, ls-sound.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

Example:

alarm.sh "2017-01-02 10:01" ~/bin/sounds/kitten.ogg
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
