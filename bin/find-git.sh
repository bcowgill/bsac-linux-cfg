#!/bin/bash
# find files that git leaves around after a merge conflict
# find-git.sh rm  to remove the files
# See also find-bak.sh find-git.sh clean-git.sh clean.sh
# WINDEV tool useful on windows development machine

LS=${1:-ls}
$LS `find . -name '*.orig' | perl -pne 's{\.orig}{?*}'`
