#!/bin/bash
# launch gnome terminal specifying an optional directory and command
# will launch using a profile name which should be configured with the desired Font and color scheme
# which is configured in .config/dconf/user
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
#echo mygterm.sh COMPANY=$COMPANY PATH=$PATH CMD=$CMD >> /tmp/BUILD.log
gnome-terminal \
	--hide-menubar \
	--working-directory="$DIR" \
	--window-with-profile=ProFontWindows18pt \
	$CMD

# --title=something
