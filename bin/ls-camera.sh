#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename...

This will show a brief listing of common camera photo/image file properties.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Shows the file name, unique image ID, file type, image size in pixels, file size, camera make, camera model, orientation, flash setting, color space, and GPS position, comment and label on a single line.

If the image has a comment, label or caption as well it will be shown on a separate labelled line.

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

# show image caption added by/using imagemagick
function show_label {
	local name file label
	name="$1"
	file="$2"
	label=`identify -format "%[$name]" "$file"`
	if [ ! -z "$label" ]; then
		echo "  $name: $label"
	fi
}

if [ -z "$2" ]; then
	FILE="$1"
	exiftool -ignoreMinorErrors -printFormat '$FileName UID:$ImageUniqueID $FileType $ImageSize $FileSize $Make $Model "$Orientation" "$Flash" $ColorSpace "$GPSPosition" "$Comment" "$Label"' "$FILE"
	show_label comment "$FILE"
	show_label label "$FILE"
	show_label caption "$FILE"
	exit 0
fi

while [ ! -z "$1" ]; do
	$0 "$1"
	shift
done
