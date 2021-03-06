#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# check if there are no local or staged changes in your git repo
# apart from untracked files
# WINDEV tool useful on windows development machine
[ 0 == `git diff | wc -l` ] && [ 0 == `git diff --staged | wc -l` ] && exit 0
echo Aborting, there are modified files:
git status --short | head
exit 1
