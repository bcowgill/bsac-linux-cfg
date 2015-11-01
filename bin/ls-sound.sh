#!/bin/bash
# list info about your sound system

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

