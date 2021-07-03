#!/bin/bash

grep -E '[‛ʼ‘‚‘’❛❜❟❟‟“”„“❝❞❠❠〝〞〝〟‹›«»]' $* | grep -vE '"\b(apos|endash|[lr][sd]q)\b"'

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [files..].

This will find lines with unicode quotes and other characters in them from standard input or files.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also utf8quotes.sh

Example:

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

