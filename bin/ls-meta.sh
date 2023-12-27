#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# TODO Show image metadata for pictures, photos, images within archive files.

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename...

This will show file metadata (id3 and exif) for audio visual media files.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Show exif or id3 v1 and v2 title information for media, picture, photo, or image files.

See also ls-music.sh ls-camera.sh id3v2-track.sh filter-id3.pl label-music.sh label-podcast.sh rename-podcast.sh get-image-size.pl identify display convert
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

if [ -z "$2" ]; then
	echo exiftool:
	exiftool "$1"
	echo id3info:
	id3info "$1"
	echo id3v2:
	id3v2 --list "$1"
	echo rdjpgcom:
	rdjpgcom -verbose "$1"
	echo "------------------------------------------------------------"
	exit 0
fi

while [ ! -z "$1" ]; do
	$0 "$1"
	shift
done

exit
file "$FILE" | grep -iE 'image|bitmap|icon|postscript|pdf|xbm|compressed'
