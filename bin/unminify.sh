#!/bin/bash
# unminify a file by using prettydiff.sh script
# find . -name '*.min.css' -exec unminify.sh {} \;
# find . -name '*.min.js' -exec unminify.sh {} \;

# see unwebpack.sh for a simpler version if prettydiff not available.
# WINDEV tool useful on windows development machine

# TODO make these flags accessible on command line
# create a pretty/ dir where the file is and unminify it there
USE_PRETTY_DIR=0
# replace the top level directory in the file name with some other path
SET_TOP_DIR=pretty/
# flag to remove .min. from filename
STRIP_MIN=1

FILE="$1"
OUT="$2"

if [ -z "$FILE" ]; then
	echo "
usage: $(basename $0) filename \[output\]

Uses prettydiff.sh to unminify a file to specified file name or to file missing the .min.
flag: USE_PRETTY_DIR=$USE_PRETTY_DIR if set will create a pretty/ dir to store the file in.
flag: SET_TOP_DIR=path/ if set will inject path before file name.
"
	exit 1
fi
if [ -z "$OUT" ]; then
	if [ ${USE_PRETTY_DIR:-0} == 1 ]; then
		DIR=`dirname "$FILE"`
		if [ ${STRIP_MIN:-0} == 1 ]; then
			NAME=`basename "$FILE" | perl -pne 's{\.min\.}{.}xms'`
		else
			NAME=`basename "$FILE"`
		fi
		DIR="$DIR/pretty"
		OUT="$DIR/$NAME"
	else
		if [ "${SET_TOP_DIR:-}" == "" ]; then
			OUT=`echo "$FILE" | perl -pne 's{\.min\.}{.}xms'`
		else
			OUT="$SET_TOP_DIR$FILE"
			if [ ${STRIP_MIN:-0} == 1 ]; then
				OUT=`echo "$OUT" | perl -pne 's{\.min\.}{.}xms'`
			fi
		fi
	fi
fi
if [ -z "$OUT" ]; then
	echo $(basename $0): no output file specified for "$FILE"
	exit 1
fi
DIR=`dirname "$OUT"`
[ -d "$DIR" ] || mkdir -p "$DIR"
echo unminify "$FILE" to "$OUT"
prettydiff.sh "$FILE" "$OUT"
