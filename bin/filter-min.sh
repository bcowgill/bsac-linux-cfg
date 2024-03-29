#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -vi"
cmd=$(basename $0)

function usage {
	local code
	code=$1
	echo "
$cmd [--regex] [--help|--man|-?] [path...]

This will filter a list of file names or grep output to suppress minified, uglified or packed  web development file extensions.

path    File names to process. If omitted then standard input will be scanned.
--regex Shows the regex used for matching web file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Also filters out debugging .map files and .git, node_modules, deno-packages and bower_components.

See also filter-built-files.sh filter-web.sh filter-text.sh, filter-docs.sh, filter-videos.sh, filter-fonts.sh, filter-scripts.sh, filter-zips.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/html

Example:

	Find your website files, filter out files that are built there then exclude any remaining minified files.

locate -i website | filter-built-files.sh | $cmd
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
	GREP=echo
fi

$GREP '(\.map|(\.|-)(min|pack)\.((c|le|sa|sc)ss|html?|ts|jsx?|json[5c]?))(:|"|\s*$)' $* # .min.css -min.css .pack.css -pack.css .css .less .sass .scss .htm .html .ts .js .jsx .json .json5 .map
ERR=$?
if [ $ERR != 0 ]; then
	usage $ERR
fi
