#!/bin/bash
# detect which monitors are attached and configure resolution/orientation with xrandr
# source `which setup-monitors.sh` will define OUTPUT_MAIN/OUTPUT_AUX/OUTPUT_RES

source `which detect-monitors.sh i3-update`

if [ ${OUTPUT_RES:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi

if [ $OUTPUT_MAIN == $OUTPUT_AUX ]; then
	# set up single monitor
	xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES
else
	# set up dual monitors to show in same resolution
# set both outputs to the same to reset a bad rotation
#		xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES \
#			--output $OUTPUT_AUX --same-as $OUTPUT_MAIN
	xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES \
		--output $OUTPUT_AUX --primary --mode $OUTPUT_RES --left-of $OUTPUT_MAIN
fi
