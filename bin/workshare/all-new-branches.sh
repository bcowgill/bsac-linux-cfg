#!/bin/bash
# create a new branch in all git repositories
# as defined by PJ and REPOS environment variables

BRANCH=$1

all-repos.sh git-new-branch.sh $BRANCH
