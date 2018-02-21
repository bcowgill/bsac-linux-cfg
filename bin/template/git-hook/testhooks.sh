#!/bin/bash
# installs the git logging hooks followed by the hooks here
rm ~/githook.log
touch ~/githook.log

echo install logging version of hooks first...
pushd ../../cfg/log-githook/
	./install.sh
popd

echo install our hooks now...
for f in applypatch-msg commit-msg git-sh-setup pre-applypatch pre-commit prepare-commit-msg pre-rebase update
do
	if [ -f $f.logged ]; then
		inject-middle.sh '\#HOOK\n' '\#/HOOK\n' $f $f.logged
		if grep function $f.logged > /dev/null ; then
			perl -i.bak -pne 's{/bin/sh}{/bin/bash}xmsg' $f.logged
		fi
		./install.sh $f.logged $f
	else
		./install.sh $f
	fi
done

# Test the prepare-commit-msg and commit-msg hooks
touch deleteme
git add deleteme
echo "a bad message from template" > template

git commit -t template
git commit -m "wip temp file to delete.a an a a a"
git commit -m "wip In change fix resolve release changed fixed resolved released changes fixes resolves releases changing fixing resolving releasing review reviews reviewed reviewing a as an at are the them there these this that i is it to too of on or and"
git commit
WORKON="wip message from WORKON var" git commit
git commit --amend
# rebase, merge and squash needs testing
rm template deleteme
