#!/bin/bash
# set up workspace for i3 window manager based on monitors attached

source `which setup-monitors.sh`

if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	touch-off.sh
fi

