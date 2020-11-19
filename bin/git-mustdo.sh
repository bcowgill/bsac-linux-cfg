#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] label

This will show what must be done to some git files.
Looks for MUSTDO markers and lists file/line number nicely.

label   Specify an alternative label to look for i.e. TODO
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

More detail ...

See also grep-lint.sh, mustdo.sh
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

LABEL=${1:-MUSTDO}
git grep -En $LABEL | perl -pne 's{\A \.+/}{}xms; s{:(\d+):\s*}{ : $1\t}xms'
