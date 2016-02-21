#!/bin/bash
# make the backlight as dark as possible


# user mode gradual change
xbacklight -set 1 -time 500 -steps 100
# superuser instant change
echo 1 | sudo tee /sys/class/backlight/intel_backlight/brightness
xbacklight -get
