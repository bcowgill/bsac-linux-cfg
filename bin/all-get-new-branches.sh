#!/bin/bash
# get a new remote branch in all git repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

BRANCH=$1
all-repos.sh git-get-remote-branch.sh $BRANCH
