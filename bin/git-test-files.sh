#!/bin/bash
# create/remove files in various states for git status testing.
# should only be run when not in a merge/rebase, etc
# WINDEV tool useful on windows development machine

function ga {
	echo git-test-files.sh test file created: $1 > $1
	git add $1
}

if [ -z "$1" ]; then
	echo creating files for git status test
	ga git-test-deleted.gittest

	ga git-test-unmoved.gittest

	git commit -m "test Adding files for git-test-files.sh testing" --no-verify

	git rm git-test-deleted.gittest
	git mv git-test-unmoved.gittest git-test-moved.gittest

	ga git-test-added.gittest
	touch git-test-untracked.gittest
else
	echo removing files from git-status test
	rm git-test-untracked.gittest
	git reset HEAD git-test-added.gittest
	git reset HEAD git-test-moved.gittest
	rm git-test-added.gittest
	rm git-test-moved.gittest

	git commit -m "test Removing files from git-test-files.sh testing" --no-verify
fi
