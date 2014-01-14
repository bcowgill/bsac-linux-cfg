#!/bin/bash
# show what files are newer than specified file.
# assumes newest reconfigure.timestamp* if none given
REGEX='/(workspace|.fontconfig|.Skype|.mozilla|(.config|.cache)/chromium)/'

if [ -z $1 ]; then
   newer=`ls -1 ~/reconfigure.timestamp* -t | head -1`
else
   newer="$1"
fi
pushd ~ > /dev/null
find . -newer $newer | egrep -v "$REGEX" 
echo NOTE: some files hidden by regex $REGEX
popd > /dev/null

