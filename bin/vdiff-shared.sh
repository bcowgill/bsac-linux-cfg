#!/bin/bash
# Visual diff files from my linux config versus versions in projects

REVERSE="$1"

function diff_them {
	local file from to reverse
	file="$1"
	from="$2"
	to="$3"
	reverse="$4"
	if diff --brief "$from/$file" "$to/$file" ; then
		echo no differences for "$file" in "$from/" or "$to/"
	else
		$DIFF "$from/$file" "$to/$file" $reverse;
	fi
}

WHICH=review-infinity-plus-dashboard
WHICH=infinity-plus-dashboard

DIFF=diff.sh
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
