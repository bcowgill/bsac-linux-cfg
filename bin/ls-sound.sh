#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# list info about your sound system
# See also alarm.sh, get-sound-level.sh, quiet.sh, sound-cards.sh, sound-control.sh, sound-down.sh, sound-level.sh, sound-not-ok.sh, sound-off.sh, sound-ok.sh, sound-play.sh, sound-set.sh, sound-test-console.sh, sound-test.sh, sound-toggle.sh, sound-up.sh, speaker-tester.sh

perl -e 'print "=" x 78, "\n"'
echo lspci audio devices
lspci -v | grep -B1 -A12 -i audio
echo " "

perl -e 'print "=" x 78, "\n"'
echo lshw audio devices
sudo lshw -quiet | grep -B1 -A10 -i audio
echo " "

perl -e 'print "=" x 78, "\n"'
echo amixer info
amixer info
echo " "

perl -e 'print "=" x 78, "\n"'
echo arecord --list-devices
arecord --list-devices
echo " "

perl -e 'print "=" x 78, "\n"'
echo aplay --list-devices
aplay --list-devices
echo " "

perl -e 'print "=" x 78, "\n"'
echo aplay --list-pcms
aplay -L

perl -e 'print "=" x 78, "\n"'
echo pactl list
pactl list

# speaker-test --test sine --frequency 1000 --nloops 1 --period 1200 --nperiods 2
# speaker-test --test pink

