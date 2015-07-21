#!/bin/bash
# set up single monitor and mouse, trackpad and keyboard settings
xrandr --output eDP1 --mode 1920x1080

# set up dual monitors to show in same resolution
xrandr --output eDP1 --mode 1920x1080 \
	--output DP1 --primary --mode 1920x1080 --left-of eDP1

touch-off.sh

# xrandr | grep connected
# eDP1 is laptop main screen
#eDP1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 346mm x 194mm
#DP1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 477mm x 268mm
#HDMI1 disconnected (normal left inverted right x axis y axis)
#HDMI2 disconnected (normal left inverted right x axis y axis)
#VGA1 disconnected (normal left inverted right x axis y axis)
#VIRTUAL1 disconnected (normal left inverted right x axis y axis)
