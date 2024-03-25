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

This will filter a list of file names or grep output looking for plain or formatted text file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the text files and show all other files.
--regex Shows the regex used for matching text file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-videos.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/md

Example:

locate -i thesis | $cmd
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

$GREP '(readme|\.(man|m[de]|u?txt|utf-?8))(:|"|\s*$)' $* # .man .md .me .txt .utxt .utf8 .utf-8
