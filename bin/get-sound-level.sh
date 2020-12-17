#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# get current master sound level
# See also alarm.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh
CARD=1

#   Mono: Playback 84 [97%] [-2.25dB] [on]
amixer -c $CARD -- sget Master playback | perl -ne 'if (m{\[(\d+\%)\]}xms) { print qq{$1\n}}'
