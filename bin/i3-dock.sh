#!/bin/bash
# dock the laptop back into the main monitor, move workspaces to targets
# TODO get these names from xrandr
MAIN=eDP1
AUX=DP1
xrandr --output $AUX --left-of $MAIN --auto
#pacmd set-sink-port 0 analog-output
sleep 3
for W in 1 2 3 4 9; do
  i3-msg "workspace $W; move workspace to output $AUX"
done
sleep 1
#xmodmap /home/lzap/.Xmodmap
#configure-input-devices
