#!/bin/bash
# Creates a percentage complete cylinder looking a bit like an AA battery
# BSACIMG part of my image manipulation tools

# Complex example from ImageMagick documentation:
# http://www.imagemagick.org/script/command-line-processing.php

set -e
#set -x

function usage {
	local code cmd
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] percent light dark text shadow

This will produce a .png image showing a battery shaped percentage complete cylinder.

percent A percentage value from 0 to 110 or 'all' to generate all values.
light   The light fill color for the percentage complete.
dark    The dark fill color for the percentage complete.
text    The text color for the percentage label.
shadow  The text shadow color for the percentage label.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The color names must be valid ImageMagick color names.  Use the command [convert -list color] to see valid color names and values.
The light color name must also support strengths 1 and 3 for use in a gradient.  i.e. if chartreuse is used then chartreuse1 and chartreuse3 will be used for gradient shading.

The image will be written to a directory and named percent-light-dark-text-shadow/percent-NNN.png

Example:

$cmd all red green blue black

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

PCT=${1:-50}
JUICE1=${2:-chartreuse}
JUICE2=${3:-green}
TEXT=${4:-red}
TEXTSHADOW=${5:-firebrick3}

function check_color
{
	local color name COLORS
	color="$1"
	name=$2
	COLORS=`convert -list color | grep "^$color " | wc -l`
	if [ $COLORS -lt 1 ]; then
		echo You must provide a known ImageMagick color name for the $name parameter. $color is not known.
		echo Use the command [convert -list color] to find suitable color names.
		exit 1
	fi
}

function check_color_strength
{
	local color name COLORS
	color="$1"
	name="$2"
	COLORS=`convert -list color | grep "^$color[13] " | wc -l`
	if [ $COLORS != 2 ]; then
		echo You must provide a color name which exists in strength 1 and 3 for the $name parameter.  ${color}1 and ${color}3 are not both valid ImageMagick color names.
		echo Use the command convert -list color to find suitable color names.
		exit 1
	fi
}

check_color $JUICE1 light
check_color $JUICE2 dark
check_color $TEXT text
check_color $TEXTSHADOW shadow
# The JUICE1 color must exist in strengths 1 & 3
check_color_strength $JUICE1 light

if [ $PCT == 'all' ]; then
	C1="$JUICE1" C2="$JUICE2" C3="$TEXT" C4="$TEXTSHADOW" perl -e 'foreach my $p (0..110) { system qq{./make-percent-cylinder.sh $p $ENV{C1} $ENV{C2} $ENV{C3} $ENV{C4}}}'
	exit 0
fi

NUM=$PCT
MINPCT=7
MAXPCT=93
if [ $NUM -gt 110 ]; then
	echo You must provide a percentage value less than or equal to 110%
	exit 1
fi
[ $NUM -lt 111 ]
if [ $NUM -lt 10 ]; then
	NUM="00$PCT"
else
	if [ $NUM -lt 100 ]; then
		NUM="0$PCT"
	fi
fi

# The drawing only works for a range of 7% to 93% and must change for 0%
FILL=gradient:$JUICE1-$JUICE2
if [ $PCT == 0 ]; then
	EPCT=$MINPCT
	FILL=gradient:white-snow4
else
	# Want 1% to correspont to 7% and 100% to correspond to 93%
	EPCT=$((86*$PCT+607))
	EPCT=$(($EPCT/99))
fi

#echo Output: $NUM
#echo Effectively $EPCT%
#echo Fill: $FILL

OFS=16
LEN=288
RAD=20

CENTER=$(($OFS+$EPCT*$LEN/100))
C1=$(($CENTER-$RAD))
C2=$(($CENTER+$RAD))

#echo Center Ellipse: $C1 $C2

OUT=percent-$JUICE1-$JUICE2-$TEXT-$TEXTSHADOW
[ -d $OUT ] || mkdir -p $OUT

# roundrectangle  X1,Y1, X2,Y2, Rx,Ry
if [ $PCT == 0 ]; then
convert -size 320x90 canvas:none \
	-stroke snow4 -size 1x90 -tile gradient:white-snow4 \
	-draw "roundrectangle  16, 5, 304, 85 20,40" +tile \
	-fill snow -draw "roundrectangle 264, 5, 304, 85 20,40" \
	-tile $FILL -draw "roundrectangle  16, 5, $C2, 85 20,40" \
	\( +clone -background snow4 -shadow 80x3+3+3 \) \
	+swap -background none -layers merge \
	\( +size -pointsize 90 -strokewidth 1 -fill $TEXT label:"$PCT%" -trim +repage \
		\( +clone -background $TEXTSHADOW -shadow 80x3+3+3 \) \
		+swap -background none -layers merge \) \
	-insert 0 -gravity center \
	-append -background white -gravity center -extent 320x200 \
	$OUT/percent-$NUM.png
#	png:- | display png:-
else
convert -size 320x90 canvas:none \
	-stroke snow4 -size 1x90 -tile gradient:white-snow4 \
	-draw "roundrectangle  16, 5, 304, 85 20,40" +tile \
	-fill snow -draw "roundrectangle 264, 5, 304, 85 20,40" \
	-tile $FILL -draw "roundrectangle  16, 5, $C2, 85 20,40" \
	-tile gradient:${JUICE1}1-${JUICE1}3 -draw "roundrectangle $C1, 5, $C2, 85 20,40" +tile \
	-fill none -draw "roundrectangle 264, 5, 304, 85 20,40" \
	-strokewidth 2 -draw "roundrectangle  16, 5, 304, 85 20,40" \
	\( +clone -background snow4 -shadow 80x3+3+3 \) \
	+swap -background none -layers merge \
	\( +size -pointsize 90 -strokewidth 1 -fill $TEXT label:"$PCT%" -trim +repage \
		\( +clone -background $TEXTSHADOW -shadow 80x3+3+3 \) \
		+swap -background none -layers merge \) \
	-insert 0 -gravity center \
	-append -background white -gravity center -extent 320x200 \
	$OUT/percent-$NUM.png
#	png:- | display png:-
fi

echo	$OUT/percent-$NUM.png
