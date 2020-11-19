#!/bin/bash
# rename a git file in same dir and adjust import references to it
# git-rename.sh src/path/filenmae.js js filename
# git-rename.sh src/path/filenmae.js js filename.js
# WINDEV tool useful on windows development machine

FULLPATH="$1"
EXT="$2"
NEWNAME="$3"

if [ -z $NEWNAME ]; then
	echo "
usage: $(basename $0) src/path/filenmae.js .js filename

This command will rename/move the file in git and correct import references to it.
"
	exit 1
fi

DIR=`dirname $FULLPATH`
FILENAME=`basename $FULLPATH`
NAME=`basename $FILENAME $EXT`
NEWNAME=`basename $NEWNAME $EXT`
NEWPATH="$DIR/$NEWNAME$EXT"
REPLACE="$NEWNAME"
echo will replace /$NAME with /$REPLACE in source code.
echo git mv "$FULLPATH" "$NEWPATH"
git mv "$FULLPATH" "$NEWPATH" \
	&& NAME="$NAME" NEWNAME="$REPLACE" perl -i.bak -pne 's{/$ENV{NAME}}{/$ENV{NEWNAME}}g' `git grep -l "/$NAME"`
