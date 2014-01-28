#!/bin/bash
# check all my svn repos for uncommitted changes
pushd $HOME > /dev/null
REPOS=`find . -type d -name .svn | perl -pne 's{\.svn \s* \z}{\n}xms'`
for dir in $REPOS
do
   pushd $dir > /dev/null
   perl -e 'print(("=" x 78) . "\n")'
   pwd
   svn status
   popd > /dev/null
done
popd > /dev/null

