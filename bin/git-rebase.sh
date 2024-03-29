#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# rebase a branch and invoke merge tool if there were conflicts
# WINDEV tool useful on windows development machine
branch="$1"
git fetch
if [ -z $branch ]; then
	git branch
	echo Specify a branch name or something to rebase from
	echo remember git merge --abort to give up!
else
	touch pause-build.timestamp
	sleep 3
	#git rebase -Xignore-all-space "$branch" || git mergetool
	git rebase -Xignore-all-space --interactive "$branch" || git mergetool
fi

# First on your local machine:
# (on local machine) switch to develop branch
# git pull (should update your develop with origin/develop - assuming that your develop is set to track origin)
# switch to the branch you wish to merge
# git rebase develop
# Deal with any conflicts (or feel free to abandon the rebase it it's just too painful)
# git push -f origin [branchname]
# Then in bitbucket:
# Reload the pull request and check it still looks OK.
# Merge the pull request
# Don't forget to pull in origin/develop before the next rebase.
