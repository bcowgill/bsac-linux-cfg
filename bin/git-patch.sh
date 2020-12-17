#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# guide to using patches to take commits from one repo to another
# https://www.lullabot.com/articles/git-best-practices-upgrading-the-patch-process
# WINDEV tool useful on windows development machine

BRANCH=$1

if [ -z "$BRANCH" ]; then
	echo "
usage: $(basename $0) branch

Will create a set of .patch files for the current branch HEAD back to the branch specified.  These patches can then be applied to a different repository.  You may want to rm *.patch before you start.

See Also:
	git help am
	git help diff
	git help format-patch

For general understanding of the patching process.
"
	git log --oneline --graph --decorate --all | head
	exit 1
fi

git format-patch $BRANCH

echo " "
echo "You can apply the above patches to another repository with 'git am --3way PATCHNAME' command.
"
