#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?] [-v] [path...]

This will filter a list of file names or grep output looking for operating system special files.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the OS special files and show all other files.
--regex Shows the regex used for matching OS special file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will filter common Windows, Mac and Linux files created for recycle bin etc.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-videos.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/ttf

Example:

	Find OS special files on a portable drive.

find /media/drive | $cmd

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

if [ "$1" == "--regex" ]; then
	shift
	GREP="echo"
fi

$GREP '(\$Recycle.Bin|\.(_.+|apdisk|DS_Store|Trash|Trash-.+|Trashes|Spotlight-V100|fseventsd|TemporaryItems))(:|"|\s*$)' $* 
ERR=$?
if [ $ERR != 0 ]; then
	usage $ERR
fi
