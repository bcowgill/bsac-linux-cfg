#!/bin/bash
# Visual diff files from my linux config versus versions in projects

REVERSE=0
if [ "$1" != "" ]; then
	REVERSE=1
fi

function diff_them {
	local file from to reverse
	file="$1"
	from="$2"
	to="$3"
	reverse="$4"
	if diff "$from/$file" "$to/$file" > /dev/null; then
		echo no differences for "$file" in "$from/" or "$to/"
	else
		if [ $reverse == 0 ]; then
			$DIFF "$from/$file" "$to/$file";
		else
			$DIFF "$to/$file" "$from/$file";
		fi
	fi
}

WHICH=review-infinity-plus-dashboard
WHICH=infinity-plus-dashboard

DIFF=diffmerge
FROM=$HOME/bin
TO=$HOME/workspace/projects/$WHICH/setup

FILE=lib-check-system.sh
diff_them $FILE $FROM $TO $REVERSE

FROM=$HOME/bin/tests
TO=$HOME/workspace/projects/$WHICH/test
FILE=shell-test.sh
diff_them $FILE $FROM $TO $REVERSE

FROM=$HOME/bin
TO=$HOME/workspace/projects/$WHICH/test
FILE=ls-tt-tags.pl
diff_them $FILE $FROM $TO $REVERSE
FILE=render-tt.pl
diff_them $FILE $FROM $TO $REVERSE

if false; then
	FROM=$HOME/
	TO=$HOME/
	FILE=
	diff_them $FILE $FROM $TO $REVERSE
fi
