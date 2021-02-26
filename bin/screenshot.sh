#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# start tool to take a screenshot interactively and keep it running

ARGS=--area
if [ ! -z "$1" ]; then
	ARGS="$*"
fi

echo Delete the file ~/_DELETE_TO_STOP_SCREENSHOTS to terminate screen shot app.
touch ~/_DELETE_TO_STOP_SCREENSHOTS
while [ -e ~/_DELETE_TO_STOP_SCREENSHOTS ]
do
	if [ `pswide.sh | grep gnome-screenshot | grep -v grep | wc -l` == "0" ]; then
		gnome-screenshot --interactive $ARGS
	fi
done
