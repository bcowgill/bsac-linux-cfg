#!/bin/bash
# undock the laptop from the main monitor
# TODO get these names from xrandr
MAIN=eDP1
AUX=DP1
xrandr --output $AUX --off
#pacmd set-sink-port 0 analog-output-speaker
sleep 2
for W in $(seq 1 10); do
  i3-msg "workspace $W; move workspace to output $MAIN"
done

