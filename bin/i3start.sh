#!/bin/bash
# set up workspace for i3 window manager based on monitors attached

RES=1920x1080

xrandr | grep ' connected'
MONITORS=`xrandr | grep ' connected' | wc -l`
MONITOR_NAMES=`xrandr | grep ' connected' | perl -pne 's{\A (\w+) .+ \z}{$1\n}xms'`

# eDP1 is laptop main screen
#eDP1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 346mm x 194mm
#DP1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 477mm x 268mm
#HDMI1 disconnected (normal left inverted right x axis y axis)
#HDMI2 disconnected (normal left inverted right x axis y axis)
#VGA1 disconnected (normal left inverted right x axis y axis)
#VIRTUAL1 disconnected (normal left inverted right x axis y axis)

if [ $MONITORS == 1 ]; then
	# set up single monitor
	MAIN=$MONITOR_NAMES
	AUX=$MAIN
	xrandr --output $MAIN --mode $RES
else
	if [ $MONITORS == 2 ]; then
		# set up dual monitors to show in same resolution
		for mon in $MONITOR_NAMES; do
			MAIN=${AUX:-$mon}
			AUX=$mon
		done
		xrandr --output $MAIN --mode $RES \
			--output $AUX --primary --mode $RES --left-of $MAIN 
	else
		echo $MONITORS monitors found, unexpected
		echo $MONITOR_NAMES
		exit 1
	fi
fi

echo MAIN=$MAIN
echo AUX=$AUX

touch-off.sh

