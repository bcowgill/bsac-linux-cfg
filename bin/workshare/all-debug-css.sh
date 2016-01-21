#!/bin/bash
# annotate all less files for debugging in repos
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		debug-css.sh $*
	popd > /dev/null
done
