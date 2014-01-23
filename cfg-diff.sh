#!/bin/bash
# backup kde/thunderbird config files for comparison
DIR=workspace/backup/settings
pushd $HOME
rm -rf $DIR
mkdir -p $DIR
cp -r .kde $DIR/kde
cp -r .thunderbird $DIR/thunderbird
echo Make some configuration changes in KDE/firefox now!
read WAIT
diffmerge .kde/ $DIR/kde &
diffmerge .thunderbird/ $DIR/thunderbird &
popd
