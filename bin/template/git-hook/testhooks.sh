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

# Test the prepare-commit-msg and commit-msg hooks
touch deleteme
git add deleteme
echo "a bad message from template" > template

git commit -t template
git commit -m "wip temp file to delete.a an a a a"
git commit
WORKON="wip message from WORKON var" git commit
git commit --amend
# rebase, merge and squash needs testing
rm template deleteme
