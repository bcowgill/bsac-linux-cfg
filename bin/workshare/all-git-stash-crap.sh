#!/bin/bash
# stash changes on all branches

pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git stash save crap
		git stash drop
	popd > /dev/null
done

