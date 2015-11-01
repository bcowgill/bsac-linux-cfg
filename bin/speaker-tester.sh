#!/bin/bash
# start a speaker test sound and wait until given program quits
# then stop the speaker test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm

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
	if ps -ef | grep -v speaker-tester.sh | grep -v grep | grep $CONTROLLER > /dev/null ; then
		/bin/true
	else
		killall speaker-test
		exit
	fi
done;

