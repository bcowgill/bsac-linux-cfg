#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# start a speaker test sound and wait until given program quits
# then stop the speaker test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh,

CONTROLLER=${1:-pavucontrol}
shift

ARGS=$*
if [ -z $1 ]; then
	ARGS="--nloops 0"
fi
if [ ${1:-nothing} == leftright ]; then
	ARGS='-c2 -t wav'
fi

echo speaker-test $ARGS
speaker-test $ARGS &

while sleep 1
do
	if pswide.sh | grep -v speaker-tester.sh | grep -v grep | grep $CONTROLLER > /dev/null ; then
		true
	else
		killall speaker-test
		exit
	fi
done;

