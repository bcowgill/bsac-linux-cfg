#!/bin/bash
# rewind your git repo until you manually stop or until ./git-should-stop.sh
# indicates you should stop.
# use this check when some manual/scripted test begins passing or failing

ORIGIN="$(git branch | grep \\* | cut -c 3-)"
BRANCH="x$ORIGIN"

echo Starting search for some manual success criteria from current git position:
echo "$ORIGIN"
git log | head -3

while true; do

echo " "

if [ -x ./git-should-stop.sh ]; then
	./git-should-stop.sh && git log | head -3 && exit 1
else
	echo "Press Ctrl-C if you want to stop here. Or ENTER to back up one commit"
	read WAIT
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
