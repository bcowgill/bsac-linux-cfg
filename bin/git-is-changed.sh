#!/bin/bash
# check if there are local changes apart from untracked files
[ 0 == `git diff | wc -l` ] && exit 1
exit 0
