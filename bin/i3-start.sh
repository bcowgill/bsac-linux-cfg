#!/bin/bash
# set up workspace for i3 window manager based on monitors attached

COMPANY=
if [ -f ~/.COMPANY ]; then
    . ~/.COMPANY
fi

source `which setup-monitors.sh`

touch-off.sh

if [ "$HOSTNAME" == "akston" ]; then
	keyboard-medium.sh
fi

swapcaps.sh
