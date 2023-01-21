#!/bin/bash
# BSACIMG part of my image manipulation tools

FILE=${1:-logo:}
SCREEN=1920x1080
source `which detect-monitors.sh` > /dev/null && SCREEN=$OUTPUT_RES_MAIN

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] image-file

This will view an image file scaling it best to fit your monitor size.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It uses detect-monitors.sh command to get the size of your main monitor.

The xrandr command gives the size of screen.

See also filter-images.sh image-crop-rotate.sh image-sort-resize.sh imgcat.sh label-photo.sh ls-camera.sh ls-meta.sh get-image-size.pl identify display convert
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

convert "$FILE" -resize $SCREEN - | display -
