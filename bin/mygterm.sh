#!/bin/bash
# launch cross-platform gnome terminal specifying an optional directory and command
# will launch using a profile name which should be configured with the desired Font and color scheme
# which is configured in .config/dconf/user
# mygterm.sh directory command

DIR=`pwd`
CMD=""
if [ ! -z "$1" ]; then
	if [ -d "$DIR" ]; then
		DIR="$1"
		shift
	fi
	CMD="$*"
fi

if [ -e /Applications ]; then
	# see mymacterm.sh for explanation
	trun_cmd=`mktemp`
	echo "cd \"$DIR\"" > $trun_cmd
	echo 'echo -n -e "\033]0;'$*'\007"' >> $trun_cmd
	echo clear >> $trun_cmd
	echo $CMD >> $trun_cmd
	echo rm $trun_cmd >> $trun_cmd
	chmod +x $trun_cmd
	open -b com.apple.terminal $trun_cmd
	exit 0
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
