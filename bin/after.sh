#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] regex-start

This will skip over everything from standard input until a line matches the regular expression given.  Then it will output everything else.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The regular expression syntax used is perl's xms syntax.  Note, you MUST escape spaces in this format (\s or \ )

Also note that \A signifies start of line and \z signifies end of line in this format.

See also prepend.sh, middle.sh, inject-middle.sh, between.sh, until.sh
"
	exit $code
}

if [ -z "$1" ]; then
	echo "You must provide a regex-start parameter."
	echo " "
	usage 1
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

REGEX="$1" perl -ne '$start = $start || m{$ENV{REGEX}}xms; print if $start'
