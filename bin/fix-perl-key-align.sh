#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# align all perl => keys at the same column

function usage {
	echo "
usage: $(basename $0) [-N] filename

This program will align all perl => key values at the same column.

If no column number is given it scans the input to find the ideal column to use.
"
	exit 1
}

if echo "$1" | egrep -- '-[0-9]+' > /dev/null; then
	COL="$1"
	shift
	if [ -z "$1" ]; then
		usage
	fi
	COLUMN="$COL" perl -i.bak -pne '
	$max = abs($ENV{COLUMN});
	if (m{\A(.+)(=>.*)\z}xms)
	{
		$prefix = length($1);
		$_ = $1 . (" " x ($max - $prefix)) . $2;
	}' $*
else
	if [ -z "$1" ]; then
		usage
	fi
	perl -ne 'if (m{\A(.+)=>})
	{
		$prefix = length($1);
		$max = $prefix if $prefix > $max;
		$_ = qq($.:$prefix> $_);
		print;
	}
	END {
		print "max column for => is $max\n";
	}' $*
fi
