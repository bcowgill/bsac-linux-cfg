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

function move_workspace {
	local WORKSPACE OUTPUT
	WORKSPACE="$1"
	OUTPUT="$3"
	echo move workspace $WORKSPACE to output $OUTPUT
	i3-msg "workspace $WORKSPACE; move workspace to output $OUTPUT" > /dev/null
}

#WORKSPACEDEF
#  do not edit settings here...
		# assign workspaces to 1 or 2 monitors
		move_workspace 10  output $OUTPUT_MAIN
		move_workspace 8   output $OUTPUT_MAIN
		move_workspace 7   output $OUTPUT_MAIN
		move_workspace 6   output $OUTPUT_MAIN
		move_workspace 5   output $OUTPUT_MAIN

		move_workspace 9   output $OUTPUT_AUX
		move_workspace 4   output $OUTPUT_AUX
		move_workspace 3   output $OUTPUT_AUX
		move_workspace 2   output $OUTPUT_AUX
		move_workspace 1   output $OUTPUT_AUX
#/WORKSPACEDEF

sleep 1
#xmodmap /home/lzap/.Xmodmap
#configure-input-devices
i3-config-update.sh
touch-off.sh
