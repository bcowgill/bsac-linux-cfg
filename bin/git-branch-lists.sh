#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# update local and remote branch lists
# WINDEV tool useful on windows development machine
MASTER=${MASTER:-master}
DEVELOP=${DEVELOP:-develop}
git branch --list --remote | grep -vE "($MASTER|$DEVELOP)" | perl -pne 's{origin/}{}xmsg' | sort > remote.branch.lst
git branch --list          | grep -vE "($MASTER|$DEVELOP)" | perl -pne 's{origin/}{}xmsg' | sort > local.branch.lst
