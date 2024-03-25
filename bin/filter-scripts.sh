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

This will filter a list of file names or grep outputlooking for executable script file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the script files and show all other files.
--regex Shows the regex used for matching script file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-videos.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/tcl

Example:

locate -i make-icon | $cmd
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

$GREP '\.(awk|sed|bat|cmd|psl|au3|php|e?rb|rspec|feature|rake|hs|groovy|tcl|python|sql|(ba?|fi|t?c|[vz])?sh|p[lmy]|tt?)(:|"|\s*$)' $* # .pl .pm .py .sh .bsh .bash .fish .tsh .tcsh .vsh .zsh .feature .hs
