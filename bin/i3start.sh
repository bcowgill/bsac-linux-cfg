#!/bin/bash
# set up single monitor and mouse, trackpad and keyboard settings
xrandr --output eDP1 --mode 1920x1080
touch-off.sh

# set up dual monitors to show in same resolution
#xrandr --output eDP1 --mode 1920x1080 \
#	--output XXX --primary --mode 1920x1080 --left-of eDP1
