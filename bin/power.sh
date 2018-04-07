#!/bin/bash
# show battery and temperature information
echo Battery: `battery-percent.sh`
#battery.sh
echo " "
if which sensors > /dev/null; then
	sensors
fi
