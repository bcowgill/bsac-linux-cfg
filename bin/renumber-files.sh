#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machin
PREFIX="$1"
SUFFIX="$2"
NAME="$3"
NUMBER=${4:-001}
NEWSUFFIX=${5:-$SUFFIX}

cmd=`basename $0`

if [ -z "$NAME" ]; then
	echo "
$cmd prefix suffix name [number] [new-suffix]

This will rename matching files starting with the number provided.
The number value defaults to 001 if omitted.

Specify TEST=1 $cmd ... as command to only test what would happen but not do it.

See also next-file.pl, auto-rename.pl, rename-files.sh, cp-random.pl, renumber-by-time.sh mv-spelling.pl mv-to-year.sh mv-camera.sh mv-apostrophe.sh rename-podcast.sh

example:

$cmd Screen .PNG error-screen- 14 .png

Will rename all the Screen*.PNG files found as error-screen-14.png etc...
"
	exit 1
fi
echo NUMBER=$NUMBER

for f in $PREFIX*$SUFFIX
do
	if [ -e "$f" ]; then
		echo mv \"$f\" \"$NAME$NUMBER$NEWSUFFIX\"
		if [ -z "$TEST" ]; then
			mv "$f" "$NAME$NUMBER$NEWSUFFIX"
		fi
		# increment number keeping 0 padding
		NUMBER=`perl -e '$n = shift; $l = length($n++); print qq{$n}' $NUMBER`
	else
		echo "$f: No matching files found"
		exit 2
	fi
done
if [ ! -z "$TEST" ]; then
	echo Dry run only, no files moved as TEST=$TEST
fi
