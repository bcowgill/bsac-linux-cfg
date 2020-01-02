#!/bin/bash
# process images by rotating and cropping them as needed
PREFIX=${1:-processed-}
ROTATE=${2:-90}
# crop percentage
WIDTH=${3:-55.6}
HEIGHT=${4:-81}

rm $PREFIX*.jpg
for photo in `ls *.jpg *.JPG *.png *.PNG`;
do
	identify $photo
	IMAGE_WIDTH=`identify -format "%w" $photo`
	IMAGE_HEIGHT=`identify -format "%h" $photo`
	CROP_WIDTH=`perl -e "print int($WIDTH * $IMAGE_WIDTH / 100)"`
	CROP_HEIGHT=`perl -e "print int($HEIGHT * $IMAGE_HEIGHT / 100)"`
	echo "crop to $WIDTH% x $HEIGHT% ($CROP_WIDTH x $CROP_HEIGHT) and then rotate $ROTATE°"
	convert $photo -crop ${CROP_WIDTH}x${CROP_HEIGHT}+0+0 -rotate $ROTATE $PREFIX$photo
	display $PREFIX$photo
done
