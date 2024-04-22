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

This will filter a list of file names or grep output to suppress files which are built or part of bower/node component system.

path    File names to process. If omitted then standard input will be scanned.
--regex Shows the regex used for matching built files.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Also filters out .git, node_modules, deno-packages and bower_components.

See also filter-code-files.sh filter-web.sh filter-text.sh, filter-docs.sh, filter-videos.sh, filter-fonts.sh, filter-scripts.sh, filter-zips.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

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
	shift
	GREP=echo
fi

$GREP '(^|/|")(\.(tmp|cache|git|cpan|nvm|p?npm|pnpm-store|idea|emacs.d|atom|WebStorm[0-9]+\.[0-9]+)|dist|coverage|node_modules|bower_components|deno-packages)(/|:|"|\s*$)' $*
ERR=$?
if [ $ERR != 0 ]; then
	usage $ERR
fi
