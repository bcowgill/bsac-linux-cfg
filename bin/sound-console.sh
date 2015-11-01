#!/bin/bash
# bring up the console alsamixer sound system controller and play a speaker test
# when the sound controller closed, turn off the test sound

# http://www.troubleshooters.com/linux/sound/sound_troubleshooting.htm

speaker-tester.sh alsamixer $* > /dev/null &
alsamixer -c 1

