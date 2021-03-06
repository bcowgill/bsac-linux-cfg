#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
ENGLISH="$HOME/bin/english/*english*.txt"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] pattern

This will search the english word lists for a matching string.

pattern An egrep search pattern to match against english words.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will ignore initially capitalised words during the search.

It searches the word lists present in $ENGLISH

See also ...

Example:

$cmd cei | wc -l

$cmd cie | wc -1

"
	exit $code
}

if [ -z "$1" ]; then
	usage 0
fi
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

# Search the english word lists, excluding capitalised names.
egrep --no-filename $1 $ENGLISH | egrep -v '^[A-Z]' | filter-newlines.pl | sort | uniq
