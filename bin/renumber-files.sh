#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machin

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] prefix suffix name [number] [new-suffix]

This will rename matching files [prefix*suffix] with a new name and renumbered starting with the number provided. [name-number.new-suffix].
The number value defaults to 001 if omitted.

TEST        Environment variable to perform a dry-run or check before renaming the files.
prefix      The initial prefix string of the files to match for renumbering.
suffix      The file extension/suffix of the files to match for renumbering.
name        The new name to assign to the files and append with a generated number.
number      The number to begin with when renumbering the files. default is 001.
new-suffix  The new file suffix to use default is the initial suffix.
--man       Shows help for this tool.
--help      Shows help for this tool.
-?          Shows help for this tool.

Specify TEST=1 $cmd ... as command to only test what would happen but not do it.

Note that no filename checking is done on the new file name so any existing numbered file will be overwritten if it already exists.

Use next-file.pl or auto-rename.pl if number collisions are likely to happen and you don't want to overwrite existing files.

See also next-file.pl, auto-rename.pl, rename-files.sh, cp-random.pl, renumber-by-time.sh mv-spelling.pl mv-to-year.sh mv-camera.sh mv-apostrophe.sh rename-podcast.sh

Example:

	Renumber the screenshots matching Screen*.PNG with new name error-screen-14.png and successive numbers.

$cmd Screen .PNG error-screen- 14 .png
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

PREFIX="$1"
SUFFIX="$2"
NAME="$3"
NUMBER=${4:-001}
NEWSUFFIX=${5:-$SUFFIX}

if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	usage 1
fi

if [ -z "$NAME" ]; then
	echo "You must provide a new name prefix for the matched files."
	usage 1
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
