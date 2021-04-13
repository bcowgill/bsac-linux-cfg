#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# https://stackoverflow.com/questions/989349/running-a-command-in-a-new-mac-os-x-terminal-window

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will start a mac terminal command in a specific directory.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also mygterm.sh, float.sh, refloat.sh
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
# create a unique file in /tmp
trun_cmd=`mktemp`
# make it cd back to where we need to be
echo "cd \"$DIR\"" > $trun_cmd
# make the title bar contain the command being run
echo 'echo -n -e "\033]0;'$CMD'\007"' >> $trun_cmd
# clear window
echo clear >> $trun_cmd
# the shell command to execute
echo $CMD >> $trun_cmd
# make the command remove itself
echo rm $trun_cmd >> $trun_cmd
# make the file executable
chmod +x $trun_cmd

# open it in Terminal to run it in a new Terminal window
open -b com.apple.terminal $trun_cmd
