#!/bin/bash
# save some stuff to dropbox for work at home
COMPANY=clearbooks
DROP=~/Dropbox/WorkSafe/_tx/$COMPANY

echo ======================================================================
date
mkdir -p $DROP
crontab -l > ~/bin/cfg/$COMPANY/crontab-$HOSTNAME

pushd ~
mkdir -p workspace/backup
popd

pushd ~/workspace
pushd projects/clearbooks-micro-api-accounting
tar cvzf $DROP/typescript-build-acct.tgz `grep -v '#' common.lst`
popd

pushd projects/clearbooks-micro-api-auth
tar cvzf $DROP/typescript-build-auth.tgz `grep -v '#' common.lst`
popd

date
echo Backup complete: $DROP
ls -al $DROP
popd

