#!/bin/bash
# find and delete backup files
if which sw_vers > /dev/null 2>&1 ; then
	# MACOS!
	find-bak.sh -delete
else
	find-bak.sh -exec rm {} \;
fi
