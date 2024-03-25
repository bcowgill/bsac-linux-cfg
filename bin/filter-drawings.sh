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

This will filter a list of file names or grep output looking for drawing, figure, vector graphic file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the drawing files and show all other files.
--regex Shows the regex used for matching drawing file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-images.sh, filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-videos.sh, filter-sounds.sh, classify.sh classify.sh

See the online file extension database https://fileinfo.com/extension/svg

Example:

locate -i site-logo | $cmd
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

$GREP '\.(dia|svg|vsd|pidgin|std|sda|sxd|oci)(:|"|\s*$)' $* # .dia .svg .vsd .pidgin .std .sda .sxd
