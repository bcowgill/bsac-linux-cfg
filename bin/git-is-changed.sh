#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# check if there are local changes apart from untracked files
# WINDEV tool useful on windows development machine
[ 0 == `git diff | wc -l` ] && exit 1
exit 0
