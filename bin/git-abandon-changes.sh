#!/bin/bash
# stash and drop your git changes

git status --short --untracked-files=no
echo WARNING: lose your uncommitted changes?  Ctrl-C to abort
read prompt
if [ ${prompt:-n} == y ]; then
	git stash save crap
	git stash drop
else
	echo aborted
fi

