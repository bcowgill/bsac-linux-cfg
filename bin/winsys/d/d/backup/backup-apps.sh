#!/bin/bash
# Make a backup copy of users app files

source setup-apps.sh

echo " "
echo "======================================================="
echo " "
echo Backing up users important application files to "$USERBAKDIR"

echo " "
echo WD Anywhere Backup
echo " "
pushd "$USERAPPDATA/WD/WD Anywhere Backup/"
tar cvzf "$USERBAKDIR/WD-Anywhere-files.tgz" --exclude "./logs/*" .
popd
pushd "$APPDATA/WD/WD Anywhere Backup/"
tar cvzf "$ROOTBAKDIR/WD-Anywhere-files.tgz" --exclude "./logs/*" .
popd

echo " "
echo Media Monkey backup
echo " "
pushd "$USERMONKEYDIR\\.."
tar cvzf $USERBAKDIR/media-monkey-files.tgz MediaMonkey
popd

echo " "
echo Stardock Fences backup
echo " "
pushd "$USERFENCESDIR\\..\\.."
tar cvzf $USERBAKDIR/fences-files.tgz Stardock/Fences
popd

echo " "
echo Cygwin backup
echo " "
pushd "$USERCYGDIR\\..\\.."
tar cvzf $USERBAKDIR/cygwin-files.tgz cygwin/home
popd

echo " "
echo Living Cookbook backup
echo " "
echo $USERCOOKBOOK
cp "$USERCOOKBOOK" $USERBAKDIR

echo " "
echo GnuCash backup
echo " "
echo $USERGNUCASH
cp "$USERGNUCASH" $USERBAKDIR

echo " "
echo Angry Birds backup
echo " "
echo $USERANGRYBIRDS
cp -r "$USERANGRYBIRDS" "$USERBAKDIR\\AppData\\Roaming"

