#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--dry-run] filename...

This will move your camera files into a subdirectory based on camera model.

--dry-run  Will not move the files but will indicate where they would end up.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

Moves image files into subdirectories based on the exif field Camera Model.

See also ls-meta.sh label-photo.sh mv-to-year.sh image-crop-rotate.sh image-sort-resize.sh identify display convert
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

MOVE=1
if [ "$1" == "--dry-run" ]; then
	MOVE=
	shift
fi

if [ -z "$2" ]; then
	FILE="$1"
	MODEL=`exiftool -ignoreMinorErrors -printFormat '$Model' "$FILE"`
	TARGET="$MODEL/$FILE"
	DIR=`dirname "$TARGET"`
	if [ -z "$MOVE" ]; then
		if [ ! -d "$DIR" ]; then
			echo mkdir -p "$DIR"
		fi
		echo mv "$FILE" "$TARGET"
	else
		if [ ! -d "$DIR" ]; then
			mkdir -p "$DIR"
		fi
		echo "$TARGET"
		mv "$FILE" "$TARGET"
	fi
	exit 0
fi

while [ ! -z "$1" ]; do
	if [ -z "$MOVE" ]; then
		$0 --dry-run "$1"
	else
		$0 "$1"
	fi
	shift
done
