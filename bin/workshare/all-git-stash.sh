#!/bin/bash
# perform a stash command on all repositories
# as defined by PJ and REPOS environment variables

all-repos.sh git stash $*
