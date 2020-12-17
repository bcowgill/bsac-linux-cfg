#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# get a remote branch from git
# WINDEV tool useful on windows development machine
branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	git branch --remote
	echo Specify a branch name minus the origin i.e. ENG-2353
else
	git fetch && git checkout --track origin/$branch
fi

