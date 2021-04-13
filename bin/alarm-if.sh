#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd check-command [sound-file] [--help|--man|-?]

A cross-platform audible alarm to sound after a given command succeeds.

check-command  command to run periodically to check if condition is met.
sound-file     a specific file to play as an alarm instead of the default one.
--man          Shows help for this tool.
--help         Shows help for this tool.
-?             Shows help for this tool.

Also emits a system notification message.

See also alarm.sh, mynotify.sh, quiet.sh, get-sound-level.sh, ls-sound.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

Example:

alarm-if.sh check.sh ~/bin/soundes/kitten.ogg
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
