#!/bin/bash
# keyboard repeat rate
# http://askubuntu.com/questions/140255/how-to-override-the-new-limited-keyboard-repeat-rate-limit
# also config file settings can be changed
# /etc/kbd/config
#sudo kbdrate -r 30.0 -d 250 -s
xset r rate 200 45

# keyboard layout
setxkbmap gb
