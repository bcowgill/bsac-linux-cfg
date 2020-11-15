#!/bin/bash
# use prettydiff javascript to clean up html
# License: http://unlicense.org
# online formatter: http://prettydiff.com/?m=beautify&html
# source: https://github.com/prettydiff/prettydiff
# source: https://github.com/austincheney/Pretty-Diff/blob/master/lib/markup_beauty.js
# npm install -g prettydiff
# WINDEV tool useful on windows development machine
INDENT_TABS=1
INDENT_SIZE=4

# CUSTOM settings you may have to change on a new computer
if [ -z $NODE ]; then
	NODE=nodejs
fi

FILE="$1"
OUTPUT="$2"
if [ -z "$1" ]; then
	echo "
usage: $(basename $0) source [output]

Will beautify an HTML file (with tabs: ${INDENT_TABS:-0} or with $INDENT_SIZE spaces)

Might beautify javascript, css and XML as well, haven't tried.
"
	exit 1
fi

PRETTYDIFF=/usr/local/lib/node_modules/prettydiff/api/node-local.js
if [ ! -f $PRETTYDIFF ]; then
	PRETTYDIFF=/usr/lib/node_modules/prettydiff/api/node-local.js
fi
if [ ! -f $PRETTYDIFF ]; then
	PRETTYDIFF=`which prettydiff`
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
