#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# perform a git diff against something and just list the files involved
# git-ls-diff.sh origin/sysqa
# WINDEV tool useful on windows development machine
git diff $* | grep 'diff --git' | perl -pne 's{diff \s --git \s a/.+ \sb/}{}xms'
