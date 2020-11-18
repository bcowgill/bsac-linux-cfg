#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] egrep-params

This will egrep all your projects as defined by PJ environment variable and filter the output through filter-built-files.sh.

PJ      where your git projects are. i.e. $HOME/workspace
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The program will change to the PJ directory then perform a recursive egrep there and pipe it through filter-built-files.sh.

The filter-built-files.sh should be on your PATH and can be used to hide results from built or minified files.

See also all-repos.sh, all-clean.sh, all-checkout.sh, all-grep.sh, all-push.sh, and others.
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

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are. i.e. $HOME/workspace
	exit 1
else
	pushd $PJ
fi

# enable to see how command line modified
if false; then
	set -x
	true egrep -r $* .
	set +x
fi

egrep -r $* . | filter-built-files.sh
