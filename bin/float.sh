#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will create a logged screen session for use as an i3 window manager floating scratch pad window.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It creates a screen session called float and logs to ~/float.log and runs your SHELL in it.

See also mygterm.sh, refloat.sh
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

# screen session to use in the i3 floating scratch pad window.
screen -D -R -U -S float -h 4096 -t bash script ~/float.log --append --command $SHELL
