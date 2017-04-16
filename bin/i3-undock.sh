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
	xrandr --output $OUTPUT_AUX2 --off
fi

#pacmd set-sink-port 0 analog-output-speaker
sleep 2
for WORKSPACE in $(seq 1 10); do
	ws=$((11 - $WORKSPACE))
	echo move workspace $ws to output $OUTPUT_MAIN
	i3-msg "workspace $ws; move workspace to output $OUTPUT_MAIN" > /dev/null
done
export OUTPUT_MAIN=
i3-config-update.sh
if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	touch-on.sh
fi
if [ "$HOSTNAME" == "brent-Aspire-VN7-591G" ]; then
	touch-on.sh
fi
