#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# identify -verbose *.jpg | egrep '(Width|Length|Orientation|Geometry|Image)'

USAGE=1
TEMPFILES=

# scale to photo frame size
MODE=${1:-copy} # or move
WIDTH=${2:-720}
HEIGHT=${3:-480}

PORTRAIT_ROTATE=90

function usage {
	cmd=$(basename $0)
	echo "
usage: $cmd [--help] mode width height

Process images for a slideshow on a photo frame show them to the user to manually rotate if needed.

This will copy or move all the image files in the current directory into portrait and landscape folders.

It will resize the images to match the photo frame dimensions.

mode  can be copy or move.  default is copy
width, height values are in pixels. default is [$WIDTH x $HEIGHT]

See also filter-images.sh image-crop-rotate.sh imgcat.sh label-photo.sh ls-camera.sh ls-meta.sh viewimg.sh get-image-size.pl identify display convert

"
	exit 0
}

[ "$MODE" == "--help" ] && usage
[ "$MODE" == "--man" ] && usage
[ "$MODE" == "-?" ] && usage

[ -e landscape ] || mkdir -p landscape
[ -e portrait ]  || mkdir -p portrait

function portrait_rotate {
	local photo output
	photo="$1"
	output="$photo"
	if [ ! -z "$PORTRAIT_ROTATE" ]; then
		output=`mktemp`
		TEMPFILES="$output $TEMPFILES"
		convert "$photo" -rotate $PORTRAIT_ROTATE $output
	fi
	OUTPUT="$output"
}

# sets var output and modifies TEMPFILES
function rotate {
	local photo rotate
	photo="$1"
	rotate="$2"

	if [ ! -z "$rotate" ]; then
		output=`mktemp`
		TEMPFILES="$output $TEMPFILES"
		convert "$photo" -auto-orient -rotate $rotate $output
	fi
}

function rotate_photo {
	local photo rotate from output
	photo="$1"
	rotate=ask
	from="$photo"
	output="$photo"

	# rotate right / left initially to set orientation
	rotate "$from" 90
	from=$output
	rotate "$from" -90
	from=$output

	while [ ! -z "$rotate" ]; do
		display "$from"
		echo "Rotate photo [Right/Left/Flip/<enter>/Exit] ? "
		read rotate

		case $rotate in
			r) echo Rotate right; rotate=90;;
			l) echo Rotate left;  rotate=-90;;
			f) echo Rotate 180;   rotate=180;;
			e) echo Exit; exit;;
			*) rotate=;;
		esac
		if [ ! -z "$rotate" ]; then
			rotate "$from" $rotate
			from=$output
		fi
	done
	OUTPUT="$output"
}

function resize_photo {
	local photo width height format to_width to_height output
	photo="$1"

	width=`identify -format "%w" "$photo"`
	height=`identify -format "%h" "$photo"`
	format=portrait
	to_width=$HEIGHT
	to_height=$WIDTH
	if [ $width -gt $height ]; then
		format=landscape
		to_width=$WIDTH
		to_height=$HEIGHT
	fi

	output=`mktemp`
	TEMPFILES="$output $TEMPFILES"
	convert "$photo" -resize ${to_width}x$to_height $output
	OUTPUT="$output"
}

function process_photo {
	local photo rotated resized width height format filename final
	photo="$1"

	if identify "$photo"; then

# 	identify -verbose "$photo" | egrep '(Width|Length|Orientation|Geometry|Image)'
		rotate_photo "$photo"
		rotated="$OUTPUT"
		resize_photo "$rotated"
		resized="$OUTPUT"

		width=`identify -format "%w" "$resized"`
		height=`identify -format "%h" "$resized"`
		format=portrait
		if [ $width -gt $height ]; then
			format=landscape
		fi
		filename=`echo $photo | W=$width H=$height perl -pne 'tr/ _/--/; s{-{2,}}{-}xmsg; s{-(landscape|portrait)}{}xmsgi; s{\d+x\d+}{}xmsg; s{(\.\w+)\s*\z}{-$ENV{W}x$ENV{H}$1}xms; s{-{2,}}{-}xmsg; s{-\.}{.}xms; s{\A-}{}xms; s{\.(JPG|PNG)}{"." . lc($1)}xmse'`

		final="$resized"
		if [ $format == portrait ]; then
			portrait_rotate "$resized"
			final="$OUTPUT"
		fi

		echo "$photo -> $format/$filename"
		cp "$final" "$format/$filename"
		identify "$format/$filename"
		if [ $MODE != 'copy' ]; then
			rm "$photo"
		fi
		rm $TEMPFILES
		TEMPFILES=
		echo " "
	fi
}

for photo in `ls *.jpg *.JPG *.png *.PNG`;
do
	USAGE=0
	process_photo "$photo"
done
rmdir landscape portrait 2> /dev/null

if [ $USAGE == 1 ]; then
	usage
fi
