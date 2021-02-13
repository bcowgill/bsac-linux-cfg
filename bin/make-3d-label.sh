#!/bin/bash
# BSACIMG part of my image manipulation tools

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] image channel

This will give a flat two-dimensional label a three-dimensional look with rich textures and simulated depth.

image   The name of the image to make into a 3D label.  defaults to the internal ImageMagick logo.
channel The color channel string.  defaults to BG giving red output.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Based on a rather complex example from ImageMagick documentation:

   http://www.imagemagick.org/script/command-line-processing.php
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

FILE=${1:-logo:}
CHAN=${2:-BG}  # for red output default
#CHAN=RG  # for blue output
#CHAN=RB  # for green output
convert "$FILE" +matte \
  \( +clone  -shade 110x90 -normalize -negate +clone  -compose Plus -composite \) \
  \( -clone 0 -shade 110x50 -normalize -channel $CHAN -fx 0 +channel -matte \) \
  -delete 0 +swap  -compose Multiply -composite \
  - | display -
