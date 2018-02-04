#!/bin/bash
# installs the git logging hooks followed by the hooks here
rm ~/githook.log
touch ~/githook.log
pushd ../../cfg/log-githook/
	./install.sh
popd

for f in prepare-commit-msg commit-msg
do
	inject-middle.sh '\#HOOK\n' '\#/HOOK\n' $f $f.logged
	./install.sh $f.logged $f
done

