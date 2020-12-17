#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# make the backlight as bright as possible

# super user instant max
#cat /sys/class/backlight/intel_backlight/max_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness

# user mode gradual brightness
xbacklight -set 100 -time 500 -steps 100
xbacklight -get
