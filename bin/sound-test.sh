#!/bin/bash
# bring up the sound system controller and play a speaker test
# when the sound controller window is closed, turn off the test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm

ls-sound.sh
pavucontrol &
speaker-tester.sh pavucontrol $* > /dev/null &
pavumeter &

