#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will list your Mac Applications a bit nicely with App name then path to it.

--man    Shows help for this tool.
--help   Shows help for this tool.
-?       Shows help for this tool.

See also ls-mac.sh find-mac.sh find-mac-more.sh find-mac-hidden.sh
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

find /Applications -name '*.app' | perl -pne 'chomp; s{\A (.+/) (.+\.app) $}{$2 $1}xmsg; $_ .= "\n"'
