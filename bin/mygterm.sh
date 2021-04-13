#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [directory] [command] [--help|--man|-?]

This will launch a cross-platform (linux, osx) terminal specifying an optional directory and command.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will launch using a profile name which should be configured with the desired Font and color scheme which is configured in .config/dconf/user

See also mymacterm.sh, float.sh, refloat.sh
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

DIR=`pwd`
CMD=""
if [ ! -z "$1" ]; then
	if [ -d "$1" ]; then
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
