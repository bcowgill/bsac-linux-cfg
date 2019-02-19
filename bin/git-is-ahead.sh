#!/bin/bash
# check if your repo has unpushed commits
git status -b -s --porcelain | head -1 | grep '\[ahead' > /dev/null && exit 0
echo There are no unpushed commits.
exit 1
