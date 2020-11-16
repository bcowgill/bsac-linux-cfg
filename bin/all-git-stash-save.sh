#!/bin/bash
# stash changes on all branches
# WINDEV tool useful on windows development machine

pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git stash save $*
	popd > /dev/null
done

