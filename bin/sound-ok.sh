#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cross-platform play an OK sound
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh,  sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

SOUND=${1:-$HOME/bin/sounds/volume_blip.wav}
sound-play.sh "$SOUND"
