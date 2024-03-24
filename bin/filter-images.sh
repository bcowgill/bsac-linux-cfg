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

This will filter a list of file names or grep output looking for image, picture, graphic file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the sound files and show all other files.
--regex Shows the regex used for matching image file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-drawings.sh, filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-videos.sh, filter-sounds.sh, classify.sh, get-image-size.pl, identify, display, convert

See the online file extension database https://fileinfo.com/extension/tga

Example:

locate -i picnic | $cmd
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

$GREP '\.(bmp|eps|gif|ico|jpe?g|miff|odi|p[bgp]m|pcx|pdf|pn[gm]|tga|tiff?|x[pb]m|xcf|xwd)(:|"|\s*$)' $* # .bmp .eps .gif .ico .jpeg .miff .odi .pbm .pgm .ppm .pcx .pdf .png .pnm .tga .tif .tiff .xpm .xbm .xcf .xwd
