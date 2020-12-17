#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cross-platform turn sound up a little and play a blip
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, speaker-tester.sh

sound-set.sh 2dB+ $*
