#!/bin/bash
# set up workspace for i3 window manager based on monitors attached

COMPANY=
if [ -f ~/.COMPANY ]; then
    . ~/.COMPANY
fi

source `which setup-monitors.sh`

if [ "$COMPANY" == "workshare" ]; then
	touch-off.sh
fi

if [ "$HOSTNAME" == "akston" ]; then
	keyboard-medium.sh
fi
swapcaps.sh
