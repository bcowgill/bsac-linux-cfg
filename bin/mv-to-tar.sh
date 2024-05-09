#!/bin/bash
# symlink archive-dir to this command as an alias.
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

DIR="`echo $1 | perl -pne 'chomp; s{/\z}{}xms'`"

cmd=$(basename $0)

ARCHIVE=`mktemp`
LOG=`mktemp`
ARCH_NAME="$DIR.tgz"

function usage {
	local code
	code=$1
	echo "
$cmd [--help|--man|-?] directory

This will move a directory to a tar compressed file with the same name and extension .tgz

directory  The name of the directory to convert to a tgz file.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will create the archive in your temporary directory and then move it in place to the destination in case your drive is low on disk space (hence the reason for converting directory to a compressed archive.)

See also mv-to-zip.sh cp-fast.sh tar gzip
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
	echo "$cmd: $ARCH_NAME: archive already exists, will not overwrite." 1>&2
	exit 2
fi

if [ ! -d "$DIR" ]; then
	echo "$cmd: '$DIR': is not a directory, stopping." 1>&2
	exit 3
fi

echo "Create a temporary archive for directory '$DIR/'"
if tar --create --verbose --gzip --file "$ARCHIVE" --remove-files --totals "$DIR" > "$LOG"; then
	if mv "$ARCHIVE" "$ARCH_NAME"; then
		COUNT=`wc -l < "$LOG"`
		echo "Directory '$DIR/' moved $COUNT files and directories to archive '$ARCH_NAME'"
		rm "$LOG" 2> /dev/null
	else
		echo "$cmd: failed to move temporary archive of '$DIR/' to archive '$ARCH_NAME'" 1>&2
		rm "$ARCHIVE" "$LOG" 2> /dev/null
		exit 10
	fi
else
	echo "$cmd: failed to create temporary archive of '$DIR/'" 1>&2
	rm "$ARCHIVE" "$LOG" 2> /dev/null
	exit 20
fi
