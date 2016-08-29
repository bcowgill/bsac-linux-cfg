#!/bin/bash
# show battery and temperature information
echo Battery: `battery-percent.sh`
#battery.sh
echo " "
sensors
