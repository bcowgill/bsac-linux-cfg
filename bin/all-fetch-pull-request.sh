#!/bin/bash
# fetch a branch with a hard reset in all git repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

BRANCH=$1

all-repos.sh git-fetch-pull-request.sh $BRANCH
