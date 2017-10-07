#!/bin/bash
# open a cross-platform gui file browser

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
