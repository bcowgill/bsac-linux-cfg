#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# checkout a branch from git remote repo
# WINDEV tool useful on windows development machine
BRANCH="$1"
git fetch && git checkout "$branch"
git branch
