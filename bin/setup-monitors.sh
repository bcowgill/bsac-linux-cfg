#!/bin/bash
# detect which monitors are attached and configure resolution/orientation with xrandr
# source `which setup-monitors.sh` will define OUTPUT_MAIN/OUTPUT_AUX/OUTPUT_RES

detect-monitors.sh i3-update
source `which detect-monitors.sh` > /dev/null

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 2
fi
if [ ${OUTPUT_AUX2:-error} == error ]; then
	exit 3
fi
if [ ${OUTPUT_RES_MAIN:-error} == error ]; then
	exit 11
fi
if [ ${OUTPUT_RES_AUX:-error} == error ]; then
	exit 12
fi
if [ ${OUTPUT_RES_AUX2:-error} == error ]; then
	exit 13
fi

set -x
if [ $OUTPUT_MAIN == $OUTPUT_AUX ]; then
	# set up single monitor
	xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES_MAIN
else
	if [ $OUTPUT_AUX == $OUTPUT_AUX2 ]; then
		# set up dual monitors to show in same resolution

		# set both outputs to the same to reset a bad rotation
		#		xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES \
		#			--output $OUTPUT_AUX --same-as $OUTPUT_MAIN

		xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES_MAIN \
			--output $OUTPUT_AUX --primary --mode $OUTPUT_RES_AUX --left-of $OUTPUT_MAIN
	else
		# set up three monitors
		xrandr --output $OUTPUT_MAIN --mode $OUTPUT_RES_MAIN \
			--output $OUTPUT_AUX --mode $OUTPUT_RES_AUX --rotate right --left-of $OUTPUT_AUX2 \
			--output $OUTPUT_AUX2 --primary --mode $OUTPUT_RES_AUX2 --left-of $OUTPUT_MAIN
	fi
fi
