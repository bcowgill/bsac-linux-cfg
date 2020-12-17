#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# set sound level cross-platform and play a blip
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

CARD=1
LEVEL=${1:-0%}
SOUND=${2:-$HOME/bin/sounds/laser.wav}
amixer -c $CARD -- sset Master playback $LEVEL
aplay -D sysdefault:CARD=PCH $SOUND
