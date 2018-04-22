#!/bin/bash
# https://stackoverflow.com/questions/1214906/how-do-i-merge-a-sub-directory-in-git

FROM_BRANCH="$1"
FROM_DIR="$2"
TO_BRANCH="$3"
TO_DIR="$FROM_DIR"

function usage
{
	local message
	message="$1"
	if [ ! -z "$message" ]; then
		echo "$message"
	fi
	echo usage: $a from-branch from-dir to-branch
	echo "
This will merge a subdirectory from one branch to another branch.
"
	exit 1
}

if [ -z "$FROM_BRANCH" ]; then
	usage "You must provide a source branch to get changes from."
fi
if [ -z "$FROM_DIR" ]; then
	usage "You must provide a subdirectory in the source branch to get changes from."
fi
if [ -z "$TO_BRANCH" ]; then
	usage "You must provide a destination branch to apply patches to."
fi

git checkout $TO_BRANCH \
	&& git merge -s ours --no-commit $FROM_BRANCH \
	&& echo "Resolve any conflicts in another terminal and come back here..." \
	&& read WAIT \
	&& git rm -r $TO_DIR \
	&& git read-tree --prefix=$TO_DIR -u $FROM_BRANCH:$FROM_DIR

echo Changes from branch $FROM_BRANCH dir $FROM_DIR have been applied to $TO_BRANCH
echo You may have conflicts to resolve before you commit.

