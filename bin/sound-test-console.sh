#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# bring up the console alsamixer sound system controller and play a speaker test
# when the sound controller closed, turn off the test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

speaker-tester.sh alsamixer $* > /dev/null &
alsamixer -c 1

