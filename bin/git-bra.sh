#!/bin/bash
# show the age of a git branch by displaying the date of the last commit
# WINDEV tool useful on windows development machine

MASTER=${MASTER:-master}
BRANCH="$1"

if [ -z "$BRANCH" ]; then
	git-fetch-pull-request.sh
	exit 1
fi

if [ "$BRANCH" == '--all' ]; then
	# get the last commit date for all remote branches
	[ -f branches.log ] && rm branches.log
	for branch in `git branch --list --remote | grep -v origin/$MASTER`
	do
		DATE=`git-bra.sh $branch 2> /dev/null | grep Date: | perl -pne 's{Date:\s+}{}xmsg;'`
		echo $DATE $branch | \
			perl -pne '
				%M = qw(Jan 01 Feb 02 Mar 03 Apr 04 May 05 Jun 06 Jul 07 Aug 08 Sep 09 Oct 10 Nov 11 Dec 12);
				s{\A\w+\s+(\w+)\s+(\d+).+?(\d\d\d\d).+(origin)}{"$3-$M{$1}-" . substr("0$2", -2) . " $4"}xmsge;
			' | \
			tee -a branches.log
	done
	exit 0
fi

git-fetch-pull-request.sh $BRANCH; git log | head -5 | grep Date:
git checkout $MASTER > /dev/null

