#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# start tool to take a screenshot interactively and keep it running

while [ true ]
do
	if [ `pswide.sh | grep gnome-screenshot | grep -v grep | wc -l` == "0" ]; then
		gnome-screenshot --interactive
	fi
done
