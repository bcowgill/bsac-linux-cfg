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
   if diff "$FROM/$FILE" "$TO/$FILE" > /dev/null; then
      echo no differences for "$FILE" in "$FROM/" or "$TO/" 
   else
      if [ $reverse == 0 ]; then
	      $DIFF "$FROM/$FILE" "$TO/$FILE";
      else
	      $DIFF "$TO/$FILE" "$FROM/$FILE";
      fi
   fi
}

DIFF=diffmerge
FROM=$HOME/bin
TO=$HOME/workspace/projects/infinity-plus-dashboard/setup

FILE=lib-check-system.sh 
diff_them $FILE $FROM $TO $REVERSE

FROM=$HOME/bin/tests
TO=$HOME/workspace/projects/infinity-plus-dashboard/test
FILE=shell-test.sh
diff_them $FILE $FROM $TO $REVERSE

FROM=$HOME/bin
TO=$HOME/workspace/projects/infinity-plus-dashboard/test
FILE=ls-tt-tags.pl
diff_them $FILE $FROM $TO $REVERSE
FILE=render-tt.pl
diff_them $FILE $FROM $TO $REVERSE

if /bin/false; then
FROM=$HOME/
TO=$HOME/
FILE=
diff_them $FILE $FROM $TO $REVERSE
fi
