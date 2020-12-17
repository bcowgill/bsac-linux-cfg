#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# rewind your git repo to find something specific
# you might have to tinker with things to get what you want exactly.
# See also git-fail-if.pl, git-rewind-manually.sh
# WINDEV tool useful on windows development machine
CHECK_FILE="$1"
SOMETHING="$2"
SOMETHINGELSE="$3"
FIND_ALL=${FIND_ALL:-0}
FIND_TO_ROOT=${FIND_TO_ROOT:-0}

ORIGIN="$(git branch | grep \\* | cut -c 3-)"
BRANCH="x$ORIGIN"

if [ "x$CHECK_FILE" == "x" ]; then
	echo please specify some file to look in.
	exit 1
fi

if [ "x$SOMETHING" == "x" ]; then
	echo please specify something to find.
	exit 1
fi

if [ "x$SOMETHINGELSE" == "x" ]; then
	echo please specify something else to find.
	exit 1
fi

echo Starting search for "$SOMETHINGELSE" within a search for "$SOMETHING" in "$CHECK_FILE" from current position:
echo "$ORIGIN"
git log | head -3

while true; do

echo " "
if [ -f $CHECK_FILE ]; then
	if grep "$SOMETHING" $CHECK_FILE | grep "$SOMETHINGELSE"; then
		echo OK found "$SOMETHINGELSE" within "$SOMETHING" in "$CHECK_FILE"
		# comment out to rewind all the way to see all matches
		if [ "${FIND_ALL:-0}" == "0" ]; then
			exit 1
		fi
	else
		echo NOT OK did not find "$SOMETHINGELSE" within "$SOMETHING" in $CHECK_FILE
		grep "$SOMETHING" $CHECK_FILE
	fi
else
	echo NOT OK $CHECK_FILE does not exist in this revision.
	echo "To get back where you started do: git checkout $ORIGIN"
	# comment out to keep going back...
	if [ "${FIND_TO_ROOT:-0}" == "0" ]; then
		exit 1
	fi
fi

# back  up the revision tree one commit and try again...
echo Back up one commit and try again.
if git checkout HEAD^ ; then
	BRANCH="$(git branch | grep \\* | cut -c 3-)"
	git log | head -3
else
	echo "To get back where you started do: git checkout $ORIGIN"
	exit 1
fi

done
