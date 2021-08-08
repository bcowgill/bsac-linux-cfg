#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename...

This will show a one liner listing of common music file properties.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Shows filename, file type, track length, file size, year, genre, artist, title, album and track number all on the same line.

See also ls-meta.sh id3v2-track.sh filter-id3.pl label-music.sh label-podcast.sh rename-podcast.sh
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
if [ -z "$1" ]; then
	usage 0
fi

exiftool -ignoreMinorErrors -printFormat '$FileName $FileType $Length $FileSize $Year "$Genre" "$Artist" "$Title" "$Album" #$Track' $*
