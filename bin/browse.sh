#!/bin/bash
# open a cross-platform gui file browser

if [ -e /Applications ]; then
	if [ -e /System/Library/CoreServices/Finder.app ]; then
		open -a Finder $*
		exit 0
	fi
fi

if which nautilus; then
	nautilus --no-desktop $* &
	exit 0
fi
if which nemo; then
	nemo --no-desktop $* &
	exit 0
fi
echo NOT OK unable to find a file browser.
exit 1
