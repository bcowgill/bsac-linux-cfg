#!/bin/bash
# backup kde/thunderbird config files for comparison
DIR=workspace/backup/settings
pushd $HOME
rm -rf $DIR
mkdir -p $DIR
cp -r .kde $DIR/kde
cp -r .config $DIR/config
#cp -r .thunderbird $DIR/thunderbird
touch reconfigure.timestamp
echo Make some configuration changes in KDE/firefox now!
read WAIT
#diffmerge --nosplash .thunderbird/ $DIR/thunderbird &
diffmerge --nosplash .kde/ $DIR/kde &
diffmerge --nosplash .config/ $DIR/config &
popd
