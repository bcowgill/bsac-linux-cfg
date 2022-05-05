#!/bin/bash
# after a cypress test run find the snapshots that have differences and view them
# deleting the snapshot so the next test run can update it.

WHERE=`find . -name '__diff_output__'`
OPEN=browser.sh

for dir in $WHERE
do
	echo $dir
	for file in $dir/*.png
	do
		# ./JIRA-NNNN-story.dev.feature/__diff_output__/brandHomePage.diff.png
		IMAGE=`echo "$file" | perl -pne 's{/__diff_output__/}{/}xms; s{\.diff\.}{.snap.}xms'`
		echo rm "$IMAGE"
		rm "$IMAGE"
		echo diff "$file"
		$OPEN "$file"
	done
	sleep 2
	rm -rf "$dir"
done
