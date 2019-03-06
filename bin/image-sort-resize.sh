#!/bin/bash
# process images for a slideshow on a photo frame.
# moves or renames photos into portrait and landscape folders
# will resize the images to match the photo frame

# identify -verbose *.jpg | egrep '(Width|Length|Orientation|Geometry|Image)'


TEMPFILES=

# scale to photo frame size
MODE=${1:-copy} # or move
WIDTH=${2:-720}
HEIGHT=${3:-480}

PORTRAIT_ROTATE=90

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

function rotate_photo {
	local photo rotate from output
	photo="$1"
	rotate=ask
	from="$photo"
	output="$photo"

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
			output=`mktemp`
			TEMPFILES="$output $TEMPFILES"
			convert "$from" -auto-orient -rotate $rotate $output
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

for photo in *.jpg;
do
	process_photo "$photo"
done
for photo in *.JPG;
do
	process_photo "$photo"
done
for photo in *.png;
do
	process_photo "$photo"
done
for photo in *.PNG;
do
	process_photo "$photo"
done
rmdir landscape portrait 2> /dev/null
