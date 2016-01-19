#!/bin/bash
# dock the laptop back into the main monitor, move workspaces to targets
source `which detect-monitors.sh`

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi

if [ ${OUTPUT_AUX2:-error} == ${OUTPUT_AUX:-error} ]; then
	xrandr --output $OUTPUT_AUX --left-of $OUTPUT_MAIN --auto
else
	xrandr --output $OUTPUT_AUX2 --left-of $OUTPUT_MAIN --auto
	xrandr --output $OUTPUT_AUX --rotate right --left-of $OUTPUT_AUX2 --auto
fi
#pacmd set-sink-port 0 analog-output
sleep 3
i3-msg "workspace 5"
# TODO set these vars from i3-config-update
for WORKSPACE in 10 9 6; do
	echo move workspace $WORKSPACE to output $OUTPUT_AUX
	i3-msg "workspace $WORKSPACE; move workspace to output $OUTPUT_AUX" > /dev/null
done
for WORKSPACE in 4 3 2 1; do
	echo move workspace $WORKSPACE to output $OUTPUT_AUX2
	i3-msg "workspace $WORKSPACE; move workspace to output $OUTPUT_AUX2" > /dev/null
done
sleep 1
#xmodmap /home/lzap/.Xmodmap
#configure-input-devices
i3-config-update.sh
touch-off.sh
