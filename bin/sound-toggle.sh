#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# toggle sound by setting master level to zero after saving current level
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-up.sh, speaker-tester.sh

CARD=1
LEVEL=`get-sound-level.sh`
SAVE=$HOME/.sound-toggle

if [ $LEVEL == 0% ]; then
	LEVEL=
	if [ -f $SAVE ]; then
		LEVEL=`cat $SAVE`
	fi
else
	echo $LEVEL > $SAVE
	LEVEL=0%
fi

LEVEL=${LEVEL:-70%}
sound-set.sh $LEVEL
