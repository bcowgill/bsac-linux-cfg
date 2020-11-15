#!/bin/bash
# WINDEV tool useful on windows development machin
PREFIX="$1"
SUFFIX="$2"
NAME="$3"
NUMBER=${4:-001}

if [ -z "$NAME" ]; then
	echo "
$0 prefix suffix name [number]

This will rename matching files starting with the number provided.
The number value defaults to 001 if omitted.

Specify TEST=1 $0 ... as command to only test what would happen but not do it.

example:

$0 Screen .png error-screen- 14

Will rename all the Screen*.png files found as error-screen-14.png etc...
"
	exit 1
fi
echo NUMBER=$NUMBER

for f in $PREFIX*$SUFFIX
do
	if [ -e "$f" ]; then
		echo mv \"$f\" \"$NAME$NUMBER$SUFFIX\"
		if [ -z "$TEST" ]; then
			mv "$f" "$NAME$NUMBER$SUFFIX"
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
