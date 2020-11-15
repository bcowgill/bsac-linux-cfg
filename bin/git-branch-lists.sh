#!/bin/bash
# update local and remote branch lists
MASTER=${MASTER:-master}
DEVELOP=${DEVELOP:-develop}
git branch --list --remote | grep -vE "($MASTER|$DEVELOP)" | perl -pne 's{origin/}{}xmsg' | sort > remote.branch.lst
git branch --list          | grep -vE "($MASTER|$DEVELOP)" | perl -pne 's{origin/}{}xmsg' | sort > local.branch.lst
