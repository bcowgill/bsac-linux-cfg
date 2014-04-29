#!/bin/bash
# unminify a file my using prettydiff.sh script
# find . -name '*.min.css' -exec unminify.sh {} \;
# find . -name '*.min.js' -exec unminify.sh {} \;

# create a pretty/ dir where the file is and unminify it there
USE_PRETTY_DIR=1

FILE="$1"
OUT="$2"

if [ -z "$FILE" ]; then
   echo Usage:
   echo $0 filename \[output\]
   echo Uses prettydiff.sh to unminify a file to specified file name or to file missing the .min.
   echo flag: USE_PRETTY_DIR=$USE_PRETTY_DIR if set will create a pretty/ dir to store the file in.
   exit 1
fi
if [ -z "$OUT" ]; then
   if [ ${USE_PRETTY_DIR:-0} == 1 ]; then
      DIR=`dirname "$FILE"`
      NAME=`basename "$FILE" | perl -pne 's{\.min\.}{.}xms'`
      DIR="$DIR/pretty"
      [ -d "$DIR" ] || mkdir -p "$DIR"
      OUT="$DIR/$NAME"
   else
      OUT=`echo "$FILE" | perl -pne 's{\.min\.}{.}xms'`
   fi 
fi
if [ -z "$OUT" ]; then
   echo $0: no output file specified for "$FILE"
   exit 1
fi
echo unminify "$FILE" to "$OUT"
prettydiff.sh "$FILE" "$OUT"
