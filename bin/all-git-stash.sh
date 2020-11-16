#!/bin/bash
# perform a stash command on all repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

all-repos.sh git stash $*
