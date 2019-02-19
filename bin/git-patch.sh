#!/bin/bash
# guide to using patches to take commits from one repo to another
# https://www.lullabot.com/articles/git-best-practices-upgrading-the-patch-process
# git help am
# git help diff
# git help format-patch

BRANCH=$1

if [ -z "$BRANCH" ]; then
	echo "usage $0 branch

Will create a set of .patch files for the current branch HEAD back to the branch specified.  These patches can then be applied to a different repository.

	"
	git log --oneline --graph --decorate --all | head
	exit 1
fi

git format-patch $BRANCH

echo " "
echo "You can apply the above patches to another repository with 'git am --3way PATCHNAME' command.
"
