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

This will filter a list of file names looking for compressed, archive file extensions.

--regex Shows the regex used for matching archive file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.


See also filter-text.sh, filter-docs.sh, filter-videos.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/zip

Example:

locate -i backup | $cmd
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

$GREP '\.(7z|cab|gz|bz2?|[jtw]?ar|tgz|zip)\b' # .7z .cab .gz .bz .bz2 .tar .jar .war .zip .tgz
