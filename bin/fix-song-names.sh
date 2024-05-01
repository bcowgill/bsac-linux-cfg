#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--go]

This will fix music file names [.mp3].  First apostrophes, then spaces and other annoying characters.

--go    Perform the actual changes to file names.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

By default it will only show you how it would rename the files. You need to specify --go option to make the changes.

See also ls-spacefiles.sh auto-rename.pl rename-files.sh mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl
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

if [ "$1" == "--go" ]; then
	shift
	GO=1
	DRY=
	EXEC=--exec
else
	GO=
	DRY=--dry
	EXEC=
fi

if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

mv-apostrophe.sh $DRY
#ls -1 | mv-spelling.pl $DRY ' ' -
rename-files.sh mp3 mp3 $EXEC

if [ -z "$GO" ]; then
	echo This was a dry run, to actually make the changes, specify: $0 --go
fi
