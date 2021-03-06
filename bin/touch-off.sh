#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# turn off the touch pad and touch screen inputs
# http://askubuntu.com/questions/65951/how-to-disable-the-touchpad
source ~/bin/touch-config.sh

for device in $TOUCH
do
	xinput --list | grep id=$device
	xinput -disable $device
done

# synclient -l is another way to control the touchpad settings
xinput list | grep -i touch
synclient TouchpadOff=1
# touch pad is 15 touch screen is 13
#xinput set-prop 15 "Device Enabled" 0
#xinput set-prop 13 "Device Enabled" 0
#xinput -disable 13

mouse-left.sh
keyboard-config.sh
