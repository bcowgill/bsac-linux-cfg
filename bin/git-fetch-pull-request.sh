#!/bin/bash
# fetch an updated pull request that someone else has rebased.

branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	git branch --remote
	echo Specify a branch name excluding the origin i.e. ENG-2353
else
	git fetch --all && git checkout $branch && git reset --hard origin/$branch
fi

