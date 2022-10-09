#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [letter]

This will list all the upper case latin or cyrillic variations of the letter specified.

letter  A letter from a to z to display variations for. If omitted it shows all variations for all letters a-z.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also ls-lower.sh, grep-utf8.sh

Example:

$cmd d
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

LETTER=$1

if [ -z "$LETTER" ]; then
	for letter in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
		$0 $letter
	done
else
	grep-utf8.sh "letter $LETTER\b" | grep -vE 'SMALL|\[(NonspacingMark|Format)\]' | grep -E 'LATIN|CYRILLIC' | perl -pne 's{\A(\S+)\s+.+\z}{ $1 }xms; END { print qq{\n\n}}'
fi
