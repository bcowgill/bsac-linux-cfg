#!/bin/bash
# fetch an updated pull request that someone else has rebased.

branch="$1"
if [ -z $branch ]; then
   git branch --remote
   echo Specify a branch name including the origin i.e. origin/ENG-2353
else
   git fetch --all
   git reset --hard $branch
fi

