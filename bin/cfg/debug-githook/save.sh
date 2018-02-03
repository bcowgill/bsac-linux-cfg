#!/bin/bash
# save the current git hook files from somewhere (default is this repo) to a tar archive here.

REPO=${1:-../../..}

if [ -d $REPO/.git/hooks ]; then
	echo OK $REPO is a git repository with a hooks dir, backing up here...
	HERE=`pwd`
	pushd $REPO && tar cvzf "$HERE/saved-hooks.tgz" .git/hooks/; popd
else
	echo You must specify a git repository with a .git/hooks directory. [$REPO]
	exit 1
fi
