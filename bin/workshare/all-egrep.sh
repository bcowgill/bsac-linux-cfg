#!/bin/bash
# egrep all repos for something filtering out built files
pushd ~/projects

if /bin/true; then
	set -x
	/bin/true egrep -r $* .
	set +x
fi

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		egrep -r $* .
	popd > /dev/null
done

