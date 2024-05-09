#!/bin/bash
# symlink zip-dir to this command as an alias.
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

DIR="`echo $1 | perl -pne 'chomp; s{/\z}{}xms'`"

cmd=$(basename $0)

ARCH_NAME="$DIR.zip"
ARCHIVE_TMP=`mktemp --directory`
ARCHIVE="$ARCHIVE_TMP/zip-dir.zip"
LOG=`mktemp`
function usage {
	local code
	code=$1
	echo "
$cmd [--help|--man|-?] directory

This will move a directory to a compressed zip file with the same name and extension .zip

directory  The name of the directory to convert to a zip file.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will create the archive in your temporary directory and then move it in place to the destination in case your drive is low on disk space (hence the reason for converting directory to a compressed archive.)

See also mv-to-tar.sh cp-fast.sh zipinfo zip unzip
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
if [ -z "$DIR" ]; then
	usage 1
fi

if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	usage 1
fi

if [ -e "$ARCH_NAME" ]; then
	echo "$cmd: $ARCH_NAME: zip archive already exists, will not overwrite." 1>&2
	exit 2
fi

if [ ! -d "$DIR" ]; then
	echo "$cmd: '$DIR': is not a directory, stopping." 1>&2
	exit 3
fi

echo "Create a temporary zip archive for directory '$DIR/'"
if zip --recurse-paths --test --move "$ARCHIVE" "$DIR" > "$LOG"; then
	if mv "$ARCHIVE" "$ARCH_NAME"; then
		COUNT=`wc -l < "$LOG"`
		echo "Directory '$DIR/' moved $[$COUNT-1] files and directories to zip archive '$ARCH_NAME'"
		rm -rf "$ARCHIVE_TMP" "$LOG" 2> /dev/null
	else
		echo "$cmd: failed to move temporary archive of '$DIR/' to zip archive '$ARCH_NAME'" 1>&2
		rm -rf "$ARCHIVE_TMP" "$LOG" 2> /dev/null
		exit 10
	fi
else
	echo "$cmd: failed to create temporary archive of '$DIR/'" 1>&2
	rm -rf "$ARCHIVE_TMP" "$LOG" 2> /dev/null
	exit 20
fi
