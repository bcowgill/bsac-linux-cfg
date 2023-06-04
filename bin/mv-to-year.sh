#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] year

This will move files or directories with the given year number in their name into a year subdirectory.

year    The year number to look for in filenames.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The year doesn't have to be a number. If you specify 'cats' then a cats directory will be created and all files and directories with cats in the name will be moved.

See also auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-camera.sh rename-files.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

Example:

Create a 1999 directory and move any files with 1999 in them into it.

$cmd 1999
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

if [ -z "$1" ]; then
	usage
fi

Y="$1"
mkdir "$Y" > /dev/null
for f in *$Y*
do
	if [ "$f" != "$Y" ]; then
		mv "$f" "$Y/"
	fi
done
