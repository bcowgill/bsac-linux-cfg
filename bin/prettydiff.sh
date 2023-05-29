#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# License: http://unlicense.org
# source: https://github.com/prettydiff/prettydiff
# source: https://github.com/austincheney/Pretty-Diff/blob/master/lib/markup_beauty.js
# WINDEV tool useful on windows development machine
INDENT_TABS=1
INDENT_SIZE=4

# CUSTOM settings you may have to change on a new computer
if [ -z $NODE ]; then
	NODE=nodejs
fi

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] source [output]

Will beautify an HTML or Javascript file indenting with tabs ${INDENT_TABS:-0} or with ${INDENT_SIZE} spaces.

Might beautify css and XML as well, haven't tried.

source  Name of file to beautify.
output  optional. Alternative file to write the output to.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Needs to have the prettydiff Javascript library installed globally.

There is an online formatter based on prettydiff at: http://prettydiff.com/?m=beautify&html

See also ...

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

FILE="$1"
OUTPUT="$2"

if [ -z "$FILE" ]; then
	echo "You must provide a source file to make pretty."
	usage 1
fi

PRETTYDIFF=/usr/local/lib/node_modules/prettydiff/api/node-local.js
if [ ! -f $PRETTYDIFF ]; then
	PRETTYDIFF=/usr/lib/node_modules/prettydiff/api/node-local.js
fi
if [ ! -f $PRETTYDIFF ]; then
	PRETTYDIFF=`which prettydiff`
fi

if [ -z "$PRETTYDIFF" ]; then
	echo "You need to have the prettydiff Javascript module globally installed to use this tool.  npm install -g prettydiff"
fi

if [ -z "$OUTPUT" ]; then
	METHOD=filescreen
else
	METHOD=file
fi
if [ "${INDENT_TABS:-}" == "1" ]; then
	# indent with tabs, use perl to help as seems no option in the node code
	if [ -z "$OUTPUT" ]; then
		$NODE $PRETTYDIFF readmethod:"filescreen" mode:"beautify" inchar:"\t" insize:"1" source:"$FILE"  | perl -pne 's{\A ((\\t)+)}{"\t" x (length($1) / 2)}xmsge'
	else
		$NODE $PRETTYDIFF readmethod:"filescreen" mode:"beautify" inchar:"\t" insize:"1" source:"$FILE"  | perl -pne 's{\A ((\\t)+)}{"\t" x (length($1) / 2)}xmsge' > "$OUTPUT"
	fi
else
	# indent with 2 spaces
	$NODE $PRETTYDIFF readmethod:"$METHOD" mode:"beautify" inchar:' ' insize:"$INDENT_SIZE" source:"$FILE" output:"$OUTPUT"
fi
