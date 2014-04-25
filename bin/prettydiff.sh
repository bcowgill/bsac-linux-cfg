#!/bin/bash
# use prettydiff javascript to clean up html
# online formatter: http://prettydiff.com/?m=beautify&html
# source: https://github.com/austincheney/Pretty-Diff/blob/master/lib/markup_beauty.js
# npm install prettydiff
PRETTYDIFF=/usr/local/lib/node_modules/prettydiff/api/node-local.js
INDENT_TABS=1
INDENT_SIZE=2

FILE="$1"
OUTPUT="$2"
if [ -z "$1" ]; then
   echo "Usage: $0 source [output]"
   echo "Will beautify an HTML file (with tabs: ${INDENT_TABS:-0} or with $INDENT_SIZE spaces)"
   echo "Might beautify javascript and XML as well, haven't tried."
   exit 1
fi
if [ -z "$OUTPUT" ]; then
   METHOD=filescreen
else
   METHOD=file
fi
if [ "${INDENT_TABS:-}" == "1" ]; then
   # indent with tabs, use perl to help as seems no option in the node code
   if [ -z "$OUTPUT" ]; then
      nodejs $PRETTYDIFF readmethod:"filescreen" mode:"beautify" inchar:"\t" insize:"1" source:"$FILE"  | perl -pne 's{\A ((\\t)+)}{"\t" x (length($1) / 2)}xmsge'
   else
      nodejs $PRETTYDIFF readmethod:"filescreen" mode:"beautify" inchar:"\t" insize:"1" source:"$FILE"  | perl -pne 's{\A ((\\t)+)}{"\t" x (length($1) / 2)}xmsge' > "$OUTPUT"
   fi
else
   # indent with 2 spaces
   nodejs $PRETTYDIFF readmethod:"$METHOD" mode:"beautify" inchar:' ' insize:"$INDENT_SIZE" source:"$FILE" output:"$OUTPUT"
fi
