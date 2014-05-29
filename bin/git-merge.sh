#!/bin/bash
# merge a branch and invoke merge tool if there were conflicts
branch="$1"
if [ -z $branch ]; then
   git branch
   echo Specify a branch name or something to merge
   echo remember git merge --abort to give up!
else
   git merge "$branch" || git mergetool
fi

