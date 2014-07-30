#!/bin/bash
# rebase a branch and invoke merge tool if there were conflicts
branch="$1"
git fetch
if [ -z $branch ]; then
   git branch
   echo Specify a branch name or something to rebase from
   echo remember git merge --abort to give up!
else
   git rebase -Xignore-all-space --interactive "$branch" || git mergetool
fi

