#!/bin/bash
# undock the laptop from the main monitor
source `which detect-monitors.sh`

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi

if [ $OUTPUT_MAIN != $OUTPUT_AUX ]; then
	xrandr --output $OUTPUT_AUX --off
fi

#pacmd set-sink-port 0 analog-output-speaker
sleep 2
for WORKSPACE in $(seq 1 10); do
	i3-msg "workspace $WORKSPACE; move workspace to output $OUTPUT_MAIN"
done
export OUTPUT_MAIN=
i3-config-update.sh
