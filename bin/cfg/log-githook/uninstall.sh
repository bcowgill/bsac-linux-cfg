#!/bin/bash
# uninstall the git hooks somewhere (default is this repo)

HOOKS=`ls *-msg pre*[ceght] post-*[hte] *-watchman *-validate *-checkout update | sort | uniq`
FOUND=`ls *-msg pre*[ceght] post-*[hte] *-watchman *-validate *-checkout update | sort | uniq | wc -l`
EXPECT=20
REPO=${1:-../../..}

if [ $EXPECT == $FOUND ]; then
	if [ -d $REPO/.git/hooks ]; then
		echo OK $REPO is a git repository with a hooks dir, uninstalling...
		pushd $REPO/.git/hooks/ && rm $HOOKS; popd
		if [ -f saved-hooks.tgz ]; then
			echo OK restoring hooks from saved-hooks.tgz
			tar xvzf saved-hooks.tgz --directory $REPO
		fi
	else
		echo You must specify a git repository with a .git/hooks directory. [$REPO]
		exit 1
	fi
else
	echo There should only be $EXPECT hook files, we found $FOUND:
	echo $HOOKS
	echo Will not update the git hooks in $REPO until this is resolved.
	exit 1
fi
