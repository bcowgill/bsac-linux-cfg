#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# WINDEV tool useful on windows development machine
# http://www.westwind.com/reference/OS-X/invisibles.html

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] directory [ls options]

This will list all hidden files a Mac (or Windows or some Linux) creates.

directory  An alternative directory to scan instead of current directory.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

See also ls-mac-apps.sh find-mac-hidden.sh find-mac.sh find-mac-more.sh
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

WHERE="${1:-.}"
shift

pushd "$WHERE" > /dev/null && ( \
	ls -a $* | egrep '(\$(Recycle.Bin)|\.(_.+|apdisk|DS_Store|Trash|Trash-.+|Trashes|Spotlight-V100|fseventsd|TemporaryItems))$'; \
	# .Trash .Trash-UID are ubuntu linux
	# $Recycle.Bin is windows
	popd > /dev/null \
)
