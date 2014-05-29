#!/bin/bash
# get a remote branch from git
branch="$1"
if [ -z $branch ]; then
   git branch --remote
   echo Specify a branch name minus the origin i.e. ENG-2353
else
   git checkout --track origin/$branch
fi

