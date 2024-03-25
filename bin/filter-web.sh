#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"
cmd=$(basename $0)

function usage {
	local code
	code=$1
	echo "
$cmd [--regex] [--help|--man|-?] [-v] [path...]

This will filter a list of file names or grep output looking for web development file extensions.
MUSTDO EXCLUDE excluding minimised and .git, node_modules, and bower_components

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the web files and show all other files.
--regex Shows the regex used for matching web file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

This will match HTML and XML documents and stylesheet formats as well as web scripting and UI templating file extensions.

See also egrep filter-min.sh filter-text.sh, filter-docs.sh, filter-videos.sh, filter-fonts.sh, filter-scripts.sh, filter-zips.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/html

Example:

locate -i website | $cmd
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
	tail -2 $cmd | perl -pne 's{\$GREP2}{Match: }; s{\$GREP}{Exclude:};'
	exit 0
fi

$GREP '\.((c|le|sa|sc)ss|md|html?|c?shtml?|x[ms]l|[jt]sx?|types\.d|json[5c]?|coffee|vue|tt|jade|hbs)(:|"|\s*$)' $* # .css .less .sass .scss .htm .html .ts .tsx .js .jsx .json .json5 .shtm .shtml .cshtm .cshtml .xml .xsl .jade .hbs .md
