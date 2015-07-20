#!/bin/bash
# turn off the touch pad and touch screen inputs
# http://askubuntu.com/questions/65951/how-to-disable-the-touchpad
# synclient -l is another way to control the touchpad settings
xinput list | grep -i touch
# touch pad is 15 touch screen is 13
synclient TouchpadOff=1
#xinput set-prop 15 "Device Enabled" 0
#xinput set-prop 13 "Device Enabled" 0
xinput -disable 13

# mouse buttons set for left handed
# http://askubuntu.com/questions/151819/how-do-i-swap-mouse-buttons-to-be-left-handed-from-the-terminal
xmodmap -e "pointer = 3 2 1"

# keyboard repeat rate
# http://askubuntu.com/questions/140255/how-to-override-the-new-limited-keyboard-repeat-rate-limit
# also config file settings can be changed
# /etc/kbd/config
#sudo kbdrate -r 30.0 -d 250 -s
xset r rate 200 45

