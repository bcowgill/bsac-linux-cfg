#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# check remote repository for what has changed.
# do a git pull to get changes after
# WINDEV tool useful on windows development machine
git remote update && git status
echo use git diff origin/master^ origin/master^^ for example to compare two previous remote changes before pulling

