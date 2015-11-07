#!/bin/bash
# find files that git leaves around after a merge conflict
# find-git.sh rm  to remove the files

LS=${1:-ls}
$LS `find . -name '*.orig' | perl -pne 's{\.orig}{?*}'`
