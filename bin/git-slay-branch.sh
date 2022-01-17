#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# git-slay-branch.sh delete a branch remotely and locally so it is gone forever.
# WINDEV tool useful on windows development machine

if [ ! -z "$2" ]; then
	for br in $*;
	do
		$0 "$br"
	done
	git remote prune origin
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0;0m' # No Color

function out {
	echo -e "$*${NC}"
}

function ok {
	out "🆗 ${GREEN}$*"
}

function warning {
	out "${YELLOW}⚠️  $*"
}

function error {
	ERROR=${1:-0}
	out "${RED}❌ ${@:2}"
}

branch=`perl -e '$_ = shift; s{origin/}{}xms; print $_' "$1"`
if [ -z $branch ]; then
	BRANCHES=`git branch --remote --merged | grep -v -- '->'`
	[ -e old-branches.lst ] && rm old-branches.lst
	for branch in $BRANCHES; do
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`" >> old-branches.lst
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`" \
			| grep -E 'years? ago'
	done
	for branch in $BRANCHES; do
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`" \
			| grep -E 'months? ago'
	done
	for branch in $BRANCHES; do
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`" \
			| grep -E 'weeks? ago'
	done
	for branch in $BRANCHES; do
		echo "$branch		`git log --format="format:%h %cr %cn %s" $branch| head -1`" \
			| grep -E 'days? ago'
	done
	error Specify a branch name i.e. origin/ENG-2353
else
	#branch=`basename "$branch"`
	warning "Delete remote branch origin/$branch [y/N] ? "
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete --remote "origin/$branch"; then
			git push --no-verify origin --delete "$branch"
			ok success
		else
			warning "Do you want to force a delete [y/N] ? "
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D --remote "origin/$branch"
			fi
		fi
		git remote prune origin
	fi

	echo Current state of local branch $branch
	git log "$branch" | head
	warning "Delete local branch $branch [y/N] ? "
	read prompt
	if [ ${prompt:-n} == y ]; then
		if git branch --delete "$branch"; then
			ok success
		else
			warning "Do you want to force a delete [y/N] ? "
			read prompt
			if [ ${prompt:-n} == y ]; then
				git branch -D "$branch"
			fi
		fi
	fi
	git branch --verbose --all | grep $branch
fi
