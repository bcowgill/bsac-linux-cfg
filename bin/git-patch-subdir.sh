#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# https://stackoverflow.com/questions/1214906/how-do-i-merge-a-sub-directory-in-git
# WINDEV tool useful on windows development machine

FROM_BRANCH="$1"
FROM_DIR="$2"
TO_BRANCH="$3"

function usage
{
	local message
	message="$1"
	if [ ! -z "$message" ]; then
		echo "$message"
	fi
	echo usage: $a from-branch from-dir to-branch
	echo "
This will pseudo-merge a subdirectory from one branch to another branch.
It does this by applying a diff patch so you lose the commit history from the other branch.
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

TMP=`mktemp`

# patch -p1 uses relative path names
git checkout $FROM_BRANCH \
	&& git diff $TO_BRANCH $FROM_DIR > $TMP \
	&& git checkout $TO_BRANCH \
	&& echo "Applying patch, answer Y to all questions." \
	&& patch --reverse -p1 < $TMP

echo Changes from branch $FROM_BRANCH dir $FROM_DIR have been applied to $TO_BRANCH
echo You may have conflicts to resolve before you commit.

rm $TMP

