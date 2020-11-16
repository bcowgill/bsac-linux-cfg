#!/bin/bash
# find and delete backup files
# See also find-bak.sh find-git.sh clean-git.sh clean.sh
# WINDEV tool useful on windows development machine
if which sw_vers > /dev/null 2>&1 ; then
	# MACOS!
	find-bak.sh -delete
else
	find-bak.sh -exec rm {} \;
fi
