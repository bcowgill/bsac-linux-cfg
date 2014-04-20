#!/bin/bash
# check all my git repos for uncommitted changes
TOP=$HOME
if [ `hostname` == WYATT ]; then
   TOP=/cygdrive/d/d/s
fi
pushd $TOP > /dev/null
REPOS=`find . -type d -name .git | grep -v Soda | perl -pne 's{\.git \s* \z}{\n}xms;'`
if [ `hostname` == WYATT ]; then
   REPOS="$HOME $REPOS"
fi
echo $REPOS
for dir in $REPOS
do
   pushd "$dir" > /dev/null
   perl -e 'print(("=" x 78) . "\n")'
   if git status | grep 'nothing to commit, working directory clean' > /dev/null; then
      echo `pwd` no changes
   else
      pwd
      git status
   fi
   popd > /dev/null
done
popd > /dev/null

