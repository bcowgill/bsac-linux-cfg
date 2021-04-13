#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will re-float the screen/terminal session in i3 if it gets closed.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also float.sh, mygterm.sh, ~/bin/i3-launch.sh configuration
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

vbox=${1:-7}
i3do "workspace $vbox; exec mygterm.sh ~ float.sh"
