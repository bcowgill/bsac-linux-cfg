#!/bin/bash
# backup kde config files for comparison
DIR=workspace/backup/kde
pushd $HOME
rm -rf $DIR
cp -r .kde $DIR
echo Make some configuration changes in KDE now!
read WAIT
diffmerge .kde/ $DIR/ &
popd
