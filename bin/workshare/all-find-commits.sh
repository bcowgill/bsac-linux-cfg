#!/bin/bash
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"
COMMIT=$1

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git log | grep $COMMIT -B 4 -A 3

	popd > /dev/null
done

