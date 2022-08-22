#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?]

This will filter a list of file names looking for executable script file extensions.

--regex Shows the regex used for matching script file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.


See also filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-videos.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

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
	GREP="echo"
fi

$GREP '\.(awk|bat|(ba?|fi|t?c|[vz])?sh|p[lmy]|php|rb|sed|tcl)\b' # .pl .pm .py .sh .bsh .bash .fish .tsh .tcsh .vsh .zsh
