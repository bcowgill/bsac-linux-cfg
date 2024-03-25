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

This will filter a list of file names or grep output looking for video, movie file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the video files and show all other files.
--regex Shows the regex used for matching video file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-mime-video.sh, filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/srt

Example:

locate -i reunion | $cmd
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

$GREP '\.(abc|as[fx]|avi|divx|fl[iv]|fxm|m2ts?|m4v|mkv|mng|mo[dv]|mp4|mp(e|g|eg)|og[mvx]|srt|swf|t[ps]|vcd|vdr|viv|vob|wmv|yuv)(:|"|\s*$)' $* # .asf .asx .avi .divx .fli .flv .m2t .m2ts .mod .mov .mpe .mpg .mpeg .ogm .ogv .ogx .tp .ts
