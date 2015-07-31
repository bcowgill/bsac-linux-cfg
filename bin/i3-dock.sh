#!/bin/bash
# dock the laptop back into the main monitor, move workspaces to targets
source `which detect-monitors.sh`

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi

xrandr --output $OUTPUT_AUX --left-of $OUTPUT_MAIN --auto
#pacmd set-sink-port 0 analog-output
sleep 3
for WORKSPACE in 1 2 3 4 9; do
	i3-msg "workspace $WORKSPACE; move workspace to output $OUTPUT_AUX"
done
sleep 1
#xmodmap /home/lzap/.Xmodmap
#configure-input-devices
i3-config-update.sh
