#!/bin/bash
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"
BRANCH=$1

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git-new-branch.sh $BRANCH
	popd > /dev/null
done

