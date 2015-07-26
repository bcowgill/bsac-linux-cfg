#!/bin/bash
# launch gnome terminal specifying an optional directory and command
# will launch using a profile name which should be configured with the desired Font and color scheme
# mygterm.sh directory command
DIR=.
CMD=""
if [ ! -z "$1" ]; then
	if [ -d "$DIR" ]; then
		DIR="$1"
		shift
	fi
	CMD="$*"
fi
if [ ! -z "$CMD" ]; then
	CMD="--execute $CMD"
fi
gnome-terminal \
	--hide-menubar \
	--working-directory="$DIR" \
	--window-with-profile=ProFontWindows18pt \
	$CMD

# --title=something
