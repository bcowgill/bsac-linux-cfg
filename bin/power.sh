#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# show battery and temperature information
echo Battery: `battery-percent.sh`
#battery.sh
echo " "
if which sensors > /dev/null; then
	sensors
fi
