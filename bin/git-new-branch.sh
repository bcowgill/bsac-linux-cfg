#!/bin/bash
# create a new feature branch local and remote from current checked out branch
NEW=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`

git branch
if [ -z "$NEW" ]; then
	echo Please specify the name of a new branch minus the origin/.
	echo use git branch --list --remote   to see all remote branches.
	exit 1
fi

echo Will create a new branch from current one. Press Enter.
read WAIT
git checkout -b "$NEW" && \
	git push --set-upstream origin "$NEW"

echo Teammates can get your branch with:
echo "git fetch && git checkout origin/$NEW"
