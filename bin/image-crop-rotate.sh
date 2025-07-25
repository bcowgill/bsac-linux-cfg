#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
PROCESSED=processed-
NINETY=90
W=55.6
H=81

USAGE=1
PREFIX=${1:-$PROCESSED}
ROTATE=${2:-$NINETY}
# crop percentage
WIDTH=${3:-$W}
HEIGHT=${4:-$H}

function usage {
	cmd=$(basename $0)
	echo "
usage: $cmd [--help] prefix rotate width height

Process images by rotating and cropping them as needed and show the result to the user.

This will process all the image files in the current directory and rename them with the prefix provided.

Warning: it will first delete all image files which match the prefix. default is $PROCESSED

A rotate amount of 90 is 90 degrees clockwise and -90 is 90 degrees counter-clockwise. default is $NINETY

The width and height values are percentages. default is [$W % x $H %]

See also filter-images.sh image-sort-resize.sh imgcat.sh label-photo.sh ls-camera.sh ls-meta.sh viewimg.sh get-image-size.pl identify display convert
"
	exit 0
}

[ "$PREFIX" == "--help" ] && usage
[ "$PREFIX" == "--man" ] && usage
[ "$PREFIX" == "-?" ] && usage

rm $PREFIX*.jpg $PREFIX*.jpeg $PREFIX*.JPG $PREFIX*.png $PREFIX*.PNG
for photo in `ls *.jpg *.jpeg *.JPG *.png *.PNG`;
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
