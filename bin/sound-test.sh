#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# bring up the sound system controller and play a speaker test
# when the sound controller window is closed, turn off the test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm
# See also alarm.sh, get-sound-level.sh, ls-sound.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

ls-sound.sh
pavucontrol &
speaker-tester.sh pavucontrol $* > /dev/null &
pavumeter &

