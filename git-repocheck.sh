#!/bin/bash
# check all my git repos for uncommitted changes
pushd $HOME > /dev/null
REPOS=`find . -type d -name .git | grep -v Soda | perl -pne 's{\.git \s* \z}{\n}xms;'`
echo $REPOS
for dir in $REPOS
do
   echo "$dir"
   pushd "$dir" > /dev/null
   perl -e 'print(("=" x 78) . "\n")'
   pwd
   git status
   popd > /dev/null
done
popd > /dev/null

