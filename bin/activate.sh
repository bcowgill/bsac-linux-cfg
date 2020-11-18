#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] javascript-file...

This will REACTIVATE some javascript files by un-commenting them out.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

To reactivate a file it removes all // DEACTIVATED comments from the start of every line and handles any jscs:enable or disable line present.

See also deactivate.sh, debug-js-on.sh debug-js-off.sh
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

# CUSTOM settings you may have to change on a new computer
for file in $*; do
	perl -i.bak -pne '
	s{\A // \s* DEACTIVATED \s* \d+ .+ \z}{}xmsge;
	s{\A //\s* \z}{\n}xmsg;
	s{\A // \s? (.+) \z}{$1}xmsg;
	s{\A (\s* jscs:(en|dis)able \w+)}{//$1}xmsg;
' $file
done
