#!/bin/bash
# checkout a branch from git remote repo
BRANCH="$1"
git fetch && git checkout "$branch"
git branch
