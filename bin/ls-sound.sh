#!/bin/bash
# list info about your sound system

echo lspci audio devices
lspci -v | grep -B1 -A12 -i audio
echo " "

echo lshw audio devices
sudo lshw -quiet | grep -B1 -A10 -i audio
echo " "

echo amixer info
amixer info
echo " "

echo arecord --list-devices
arecord --list-devices
echo " "

echo aplay --list-devices
aplay --list-devices
echo " "

echo aplay --list-pcms
aplay -L

# speaker-test --test sine --frequency 1000 --nloops 1 --period 1200 --nperiods 2
# speaker-test --test pink

