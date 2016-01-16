#!/bin/bash
# perform a git diff against something and just list the files involved
# git-ls-diff.sh origin/sysqa
git diff $* | grep 'diff --git' | perl -pne 's{diff \s --git \s a/.+ \sb/}{}xms'
