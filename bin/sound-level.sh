#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# set Master sound level to 50% for all sound cards
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

level=${1:-100%}

for card in `sound-cards.sh`
do
	echo card: $card
	for mixer in Master IEC958
	do
		amixer -c $card -- sset $mixer playback $level 2> /dev/null
	done
done

