#!/bin/bash
# start tool to take a screenshot interactively and keep it running

while [ /bin/true ]
do
	if [ `ps -ef --cols 256 | grep gnome-screenshot | grep -v grep | wc -l` == "0" ]; then
		gnome-screenshot --interactive
	fi
done
