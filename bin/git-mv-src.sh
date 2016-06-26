#!/bin/bash
# git-mv-src.sh source-file target-dir
# move a source file somewhere else and adjust all import statements
# which are affected by it. Only support moving directories, not rename.

DEBUG=1

SOURCE="$1"
DIR=`echo "$2" | perl -pne 'chomp; s{/ \z}{}xmsg'`

FILE=`basename "$SOURCE"`
BASENAME=`echo "$FILE" | perl -pne 'chomp; s{ \. (js|css|less|s[ac]ss) \z }{}xmsg'`
TARGET="$DIR/$FILE"

function usage
{
	if [ ! -z "$1" ]; then
		echo "error: $1
" >&2
	fi
	echo "`basename $0` source-file target-dir

Move a git controlled source file to a new location and adjust all require or import statements which are affected.

"
	exit 1
}

[ ! -z "$SOURCE" ] || usage "you must specify a source file"
[ ! -z "$DIR" ] || usage "you must specify a target directory"

[ -e "$SOURCE" ]   || usage "file '$SOURCE' does not exist!"
[ -d "$DIR" ]      || usage "directory '$DIR' does not exist!"
[ ! -e "$TARGET" ] || usage "target file '$TARGET' already exists, will not overwrite!"

if [ ${DEBUG:-0} == 1 ]; then
	echo TARGET="$TARGET"
	echo FILE="$FILE"
	echo BASENAME="$BASENAME"
fi

RELATED=`git grep -lE "(import|require).+\b$BASENAME\b"`
echo RELATED=$RELATED

echo ""
echo imports to fix up in "$SOURCE"
perl -ne '$q=chr(39); print if m{(import|require).+[$q"]\.}' "$SOURCE" | grep -E --color '\..+$'

echo ""
echo imports to fix up in related files which import "$SOURCE"
git grep -E "(import|require).+\b$BASENAME\b"

echo ""

touch pause-build.timestamp
echo git mv "$SOURCE" "$TARGET"


# correct imports within the source file itself
# src/X/File
# move to src/Y/Z/File
# import './Something'  # import from X dir
# becomes import '../../X/Something'
# import './sub/Something'
# becomes import '../../X/sub/Something'
# import '../Y/Z/Something'
# becomes import './Something'
# import '../Y/W/Something'
# becomes import '../W/Something'

# correct imports within all related files which import the moved file
# src/X/File
# move to src/Y/Z/File
# src/X/Something.js: import './File'
# becomes import '../Y/Z/File'
# src/Something.js: import './X/File'
# becomes import './Y/Z/File'
# src/X/W/Something.js: import '../File'
# becomes import '../../Y/Z/File
# src/Y/Something.js: import '../X/File'
# becomes import './Z/File'
# src/Y/Z/Something.js: import '../../X/File'
# becomes import './File'
# src/Y/Z/W/Something.js: import '../../../X/File'
# becomes import './W/File'
