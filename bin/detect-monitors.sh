#!/bin/bash
# detect which monitors are attached and configure resolution/orientation with xrandr
# source `which detect-monitors.sh` will define OUTPUT_MAIN/OUTPUT_AUX/OUTPUT_RES

RES=1920x1080

if [ ${1:-quiet} == show ]; then
	# if show option provided, show all resolutions with computed aspect ratio
	xrandr | perl -pne 's{\s{2}(\d+)x(\d+)\s{2}}{qq{  $1x$2  @{[substr($1/$2,0,7)]}}}xmsge'
else
	xrandr | grep ' connected'
fi

MONITORS=`xrandr | grep ' connected' | wc -l`
MONITOR_NAMES=`xrandr | grep ' connected' | perl -pne 's{\A (\w+) .+ \z}{$1\n}xms'`

# eDP1 is laptop main screen
#eDP1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 346mm x 194mm
#DP1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 477mm x 268mm
#HDMI1 disconnected (normal left inverted right x axis y axis)
#HDMI2 disconnected (normal left inverted right x axis y axis)
#VGA1 disconnected (normal left inverted right x axis y axis)
#VIRTUAL1 disconnected (normal left inverted right x axis y axis)

if xrandr | egrep '   ' | grep $RES > /dev/null ; then
	echo resolution $RES ok
else
	echo did not detect desired resolution $RES
	exit 1
fi
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
# set both outputs to the same to reset a bad rotation
#		xrandr --output $MAIN --mode $RES \
#			--output $AUX --same-as $MAIN
		xrandr --output $MAIN --mode $RES \
			--output $AUX --primary --mode $RES --left-of $MAIN 
	else
		echo $MONITORS monitors found, unexpected
		echo $MONITOR_NAMES
		exit 1
	fi
fi

OUTPUT_MAIN=$MAIN
OUTPUT_AUX=$AUX
OUTPUT_RES=$RES
export OUTPUT_MAIN OUTPUT_AUX OUTPUT_RES
echo OUTPUT_MAIN=$OUTPUT_MAIN
echo OUTPUT_AUX=$OUTPUT_AUX
echo OUTPUT_RES=$OUTPUT_RES
