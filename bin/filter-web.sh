#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -vi"
CR="|"
GREP2="egrep -i"
cmd=$(basename $0)

function usage {
	local code
	code=$1
	echo "
$cmd [--help|--man|-?]

This will filter a list of file names looking for web development file extensions excluding minimised and .git, node_modules, and bower_components.

--regex Shows the regex used for matching web file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.
See also filter-text.sh, filter-docs.sh, filter-videos.sh, filter-fonts.sh, filter-scripts.sh, filter-zips.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

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

$GREP '(\.|-)(min|pack)\.((c|le|sa|sc)ss|html?|ts|jsx?|json5?)\b' \
	| $GREP2 '\.((c|le|sa|sc)ss|html?|ts|jsx?|json5?)\b' # .css .less .sass .scss .htm .html .ts .js .jsx .json .json5