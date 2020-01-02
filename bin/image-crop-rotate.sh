#!/bin/bash
USAGE=1
PREFIX=${1:-processed-}
ROTATE=${2:-90}
# crop percentage
WIDTH=${3:-55.6}
HEIGHT=${4:-81}

function usage {
	cmd=$(basename $0)
	echo "
usage: $cmd [--help] prefix rotate width height

Process images by rotating and cropping them as needed and show the result to the user.

This will process all the image files in the current directory and rename them with the prefix provided.

Warning: it will first delete all image files which match the prefix. default is $PREFIX

A rotate amount of 90 is 90 degrees clockwise and -90 is 90 degrees counter-clockwise. default is $ROTATE

The width and height values are percentages. default is [$WIDTH % x $HEIGHT %]
"
	exit 0
}

[ "$PREFIX" == "--help" ] && usage
[ "$PREFIX" == "--man" ] && usage
[ "$PREFIX" == "-?" ] && usage

rm $PREFIX*.jpg
for photo in `ls *.jpg *.JPG *.png *.PNG`;
do
	USAGE=0
	identify $photo
	IMAGE_WIDTH=`identify -format "%w" $photo`
	IMAGE_HEIGHT=`identify -format "%h" $photo`
	CROP_WIDTH=`perl -e "print int($WIDTH * $IMAGE_WIDTH / 100)"`
	CROP_HEIGHT=`perl -e "print int($HEIGHT * $IMAGE_HEIGHT / 100)"`
	echo "crop to $WIDTH% x $HEIGHT% ($CROP_WIDTH x $CROP_HEIGHT) and then rotate $ROTATE°"
	convert $photo -crop ${CROP_WIDTH}x${CROP_HEIGHT}+0+0 -rotate $ROTATE $PREFIX$photo
	display $PREFIX$photo
done

if [ $USAGE == 1 ]; then
	usage
fi
