#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path-to-scan

This will scan all directories in the PATH or path-to-scan and list every executable it finds with or without the absolute path.

--full  Shows the full path to each executable instead of just the command name.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also ls-cmds-used.sh

Example:

Find all short command names on the path except for shell and perl scripts and sort them.

ls-cmds.sh | grep -vE '\.(sh|pl)$' | sort
...
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
FULL=
if [ "$1" == "--full" ]; then
	FULL=1
	shift
fi
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

PTH="$*"
if [ -z "$PTH" ]; then
	PTH="$PATH"
fi
PTH="${PTH//:/ }"

# show the path on stderr
# >&2 echo Using PATH="$PTH"

if [ $FULL ]; then
	find $PTH -maxdepth 1 -type f -executable
else

	find $PTH -maxdepth 1 -type f -executable | perl -pne 's{\A.+/}{}xms'
fi
