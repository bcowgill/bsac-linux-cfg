#!/bin/bash
# git-slay-branch.sh delete a branch remotely and locally so it is gone forever.

branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	git branch --remote --verbose
	echo Specify a branch name excluding the origin i.e. ENG-2353
else
	echo Delete remote branch origin/$branch [y/N] ?
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete --remote origin/$branch; then
			echo success
		else
			echo Do you want to force a delete [y/N] ?
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D --remote origin/$branch
			fi
		fi
	fi

	echo Delete local branch $branch [y/N] ?
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete $branch; then
			echo success
		else
			echo Do you want to force a delete [y/N] ?
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D $branch
			fi
		fi
	fi
fi

git branch --verbose --all | grep $branch

