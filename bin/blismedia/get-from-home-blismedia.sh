#!/bin/bash
# grab archive from home
DROP=~/Dropbox/WorkSafe/_tx/blismedia
PUT=~/tx/from-home
[ -d $PUT ] ||  mkdir -p $PUT
pushd $PUT
tar xvzf $DROP/work-at-home.tgz
popd

diffmerge --nosplash notes/ ~/workspace/

