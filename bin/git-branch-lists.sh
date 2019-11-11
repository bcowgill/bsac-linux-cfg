#!/bin/bash
# update local and remote branch lists
git branch --list --remote | grep -vE '(master|develop)' | perl -pne 's{origin/}{}xmsg' | sort > remote.branch.lst
git branch --list          | grep -vE '(master|develop)' | perl -pne 's{origin/}{}xmsg' | sort > local.branch.lst
