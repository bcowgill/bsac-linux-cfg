#!/bin/bash
# git-slay-branch.sh delete a branch remotely and locally so it is gone forever.

branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	BRANCHES=`git branch --remote --merged | grep -v -- '->'`
	for branch in $BRANCHES; do
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`"
	done
	echo Specify a branch name i.e. origin/ENG-2353
else
	#branch=`basename "$branch"`
	echo Delete remote branch origin/$branch [y/N] ?
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete --remote "origin/$branch"; then
			git push origin --delete "$branch"
			echo success
		else
			echo Do you want to force a delete [y/N] ?
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D --remote "origin/$branch"
			fi
		fi
		git remote prune origin
	fi

	echo Delete local branch $branch [y/N] ?
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete "$branch"; then
			echo success
		else
			echo Do you want to force a delete [y/N] ?
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D "$branch"
			fi
		fi
	fi
	git branch --verbose --all | grep $branch
fi
