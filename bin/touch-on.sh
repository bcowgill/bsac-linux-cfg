#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# turn on the touch pad and touch screen inputs
source ~/bin/touch-config.sh
synclient TouchpadOff=0

for device in $TOUCH
do
	xinput --list | grep id=$device
	xinput -enable $device
done

keyboard-config.sh
