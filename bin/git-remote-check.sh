#!/bin/bash
# check remote repository for what has changed.
# do a git pull to get changes after
git remote update && git status
echo use git diff origin/master^ origin/master^^ for example to compare two previous remote changes before pulling

