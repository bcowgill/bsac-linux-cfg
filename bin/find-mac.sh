#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [find-options]

This will find in your Mac \$HOME dir ignoring Applications, Library and some other directories (.git, node_modules).

find-options   Additional options to pass to the find command.
--man          Shows help for this tool.
--help         Shows help for this tool.
-?             Shows help for this tool.

See also find-mac-more.sh ls-mac-apps.sh find-mac-hidden.sh ls-mac.sh scan-tree.sh lokate.sh locate(1) find
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

if [ -z "$1" ]; then
	GO="-print"
fi

pushd ~ > /dev/null && ( \
	find . -path ./Library -prune \
		-o -path ./Applications -prune \
		-o -name .git -prune \
		-o -name node_modules -prune \
		-o ${GO:-$@} ; \
	popd > /dev/null \
)
