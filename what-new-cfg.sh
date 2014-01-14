#!/bin/bash
# show what files are newer than specified file.
# assumes newest reconfigure.timestamp* if none given
if [ -z $1 ]; then
   newer=`ls -1 ~/reconfigure.timestamp* -t | head -1`
else
   newer="$1"
fi
pushd ~
find . -newer $newer | egrep -v "/(workspace|.fontconfig|.Skype|.mozilla|(.config|.cache)/chromium)/" 
popd

