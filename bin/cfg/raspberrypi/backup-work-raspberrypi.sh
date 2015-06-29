#!/bin/bash
# save some stuff to dropbox for work at home
COMPANY=$HOSTNAME
DROP=~/Dropbox/WorkSafe/_tx/$COMPANY

echo ======================================================================
date
mkdir -p $DROP
crontab -l > ~/bin/cfg/crontab-$HOSTNAME

pushd ~
mkdir -p workspace/backup
popd

pushd ~/workspace

date
echo Backup complete: $DROP
ls -al $DROP
popd

