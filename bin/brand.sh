#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

# Show a sample of each of my branded comments for marking code in different classifications.
# (ggr WIND|head -1; ggr BSACK|head -1; ggr -B 2 BSACS|head -2;ggr CUST|head -1; ggr '# WIP'|head -1) | perl -pne 's{\A[^#]+#\s*}{}xms'

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] filename ...

This will inject the BSACKIT brand comment line after the shebang if needed.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

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

BRAND=`grep BSACKIT $0 | head -1`
for file in $*
do
	if grep BSACKIT "$file" > /dev/null ; then
		echo $file: already branded.;
	else
		echo $file: adding BSACKIT brand comment. $BRAND
		BRAND="$BRAND" perl -i -pne 'if (m{\A\#!}xms) { $_ = qq{$_$ENV{BRAND}\n};  }' "$file"
	fi
done
