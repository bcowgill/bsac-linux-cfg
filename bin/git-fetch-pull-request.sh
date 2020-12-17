#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# fetch an updated pull request that someone else has rebased.
# WINDEV tool useful on windows development machine

branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	git fetch --all && git branch --list --remote
	echo Specify a branch name excluding the origin i.e. ENG-2353
else
	git fetch --all && git checkout $branch && git reset --hard origin/$branch
fi

