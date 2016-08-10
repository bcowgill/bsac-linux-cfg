#!/bin/bash
# git-mv-src.sh source-file target-dir
# move a source file somewhere else and adjust all import statements
# which are affected by it. Only support moving directories, not rename.
# But support creating an index linker file.

DEBUG=${DEBUG:-0}
MODE=${MODE:-git} # git, mv or cp

SOURCE="$1"
DIR=`echo "$2" | perl -pne 'chomp; s{/ \z}{}xmsg'`

function base
{
	local file
	file="$1"
	BASE=`echo "$file" | perl -pne 'chomp; s{ \. (jsx?|css|less|s[ac]ss) \z }{}xmsg'`
}

function ext
{
	local file
	file="$1"
	EXT=`echo "$file" | perl -pne 'chomp; m{ \. (jsx?|css|less|s[ac]ss) \z }xs; $_ = $1'`
}

function makedir
{
	local dir
	dir="$1"

	if [ ${DEBUG:-0} == 0 ]; then
		mkdir -p "$dir"
	fi
}

if [ ! -z "$3" ]; then
	LINK=1
	FILE="$3"
	base "$FILE"
	BASEFILE="$BASE"
	ext "$FILE"
	BASENAME=`basename $SOURCE`
	base "$BASENAME"
	BASENAME="$BASE"
	NEWNAME=`basename $DIR`
	LINKTARGET="$DIR/$FILE"
	TARGET="$DIR/$NEWNAME.$EXT"
	IMPORT="$DIR"
else
	LINK=0
	FILE=`basename "$SOURCE"`
	base "$FILE"
	ext "$FILE"
	BASEFILE="$BASE"
	BASENAME="$BASEFILE"
	NEWNAME="$BASEFILE"
	TARGET="$DIR/$FILE"
	LINKTARGET="$TARGET"
	IMPORT="$DIR/$NEWNAME"
fi

function usage
{
	if [ ! -z "$1" ]; then
		echo "error: $1
" >&2
	fi
	echo "`basename $0` source-file target-dir/ [target-file]

Move a git controlled source file to a new location and adjust all require or import statements which are affected. It modifies the moved file and other git controlled files which import the moved file.

It does not support renaming a source file.
It does not support absolute path names in the from and moved to file names.
It only affects imports which have a relative path indication.

These would be corrected:

... import .... './path/Object'
... require ... '../path/Object'
... requireJson ... '../path/Object'

These would not be corrected:

... import .... 'path/Object'

"
	exit 1
}

[ ! -z "$SOURCE" ] || usage "you must specify a source file"
[ ! -z "$DIR" ] || usage "you must specify a target directory"

[ -e "$SOURCE" ]   || usage "file '$SOURCE' does not exist!"

if [ $LINK == 1 ]; then
   [ "$FILE" == "index.js" ] || usage "you can only rename to index.js at present, not [$FILE]"
fi

[ "$BASENAME" == "$NEWNAME" ] || usage "you cannot rename at present [$BASENAME] must equal [$NEWNAME]"

[ ! -e "$TARGET" ] || usage "target file '$TARGET' already exists, will not overwrite!"
[ ! -e "$LINKTARGET" ] || usage "target file '$LINKTARGET' already exists, will not overwrite!"

[ -d "$DIR" ]      || (echo "directory '$DIR' does not exist, creating it." && makedir "$DIR")

RELATED=`git grep -lE "(import|require|requireJson).+\b$BASENAME\b"`

if [ ${DEBUG:-0} == 1 ]; then
	echo TARGET="$TARGET"
	echo LINKTARGET="$LINKTARGET"
	echo FILE="$FILE"
	echo EXT="$EXT"
	echo BASEFILE="$BASEFILE"
	echo BASENAME="$BASENAME"
	echo NEWNAME="$NEWNAME"
	echo RELATED=$RELATED

	echo ""
	echo imports to fix up in "$SOURCE"
	perl -ne '$q=chr(39); print if m{(import|require|requireJson).+[$q"]\.}' "$SOURCE" | grep -E --color '\..+$'

	echo ""
	echo imports to fix up in related files which import "$SOURCE" as $BASENAME
	git grep -E "(import|require|requireJson).+\b$BASENAME\b"
	echo ""
	echo example import $NEWNAME from $IMPORT
   echo log to moved.lst: moved $SOURCE $TARGET
	if [ $LINK == 1 ]; then
		echo "$LINKTARGET: import $NEWNAME from './$NEWNAME'; export default $NEWNAME"
	fi
	echo ""
   echo would fix-import.pl "$SOURCE" "$LINKTARGET" $RELATED
fi

if [ ${DEBUG:-0} == 0 ]; then
	echo moved $SOURCE $TARGET >> moved.lst
	touch pause-build.timestamp
	sleep 3

	if [ "$MODE" == "mv" ]; then
		mv "$SOURCE" "$TARGET"
	else
		if [ "$MODE" == "cp" ]; then
			cp "$SOURCE" "$TARGET"
		else
			git mv "$SOURCE" "$TARGET"
		fi
	fi

	if [ $LINK == 1 ]; then
		echo "import $NEWNAME from './$NEWNAME'" > "$LINKTARGET"
      echo "export default $NEWNAME" >> "$LINKTARGET"
	fi
fi

DRY_RUN=$DEBUG fix-import.pl "$SOURCE" "$LINKTARGET" $RELATED
