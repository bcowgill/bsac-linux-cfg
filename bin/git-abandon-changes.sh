#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# stash and drop your git changes
# WINDEV tool useful on windows development machine
git status --short --untracked-files=no
echo WARNING: lose your uncommitted changes? [y/Ctrl-C to abort]
read prompt
if [ ${prompt:-n} == y ]; then
	git stash save crap | grep 'No local changes' || git stash drop;
else
	echo aborted
fi

