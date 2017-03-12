#!/bin/bash
# Make a backup copy of users app files

source setup-apps.sh

echo " "
echo "======================================================="
echo " "
echo Backing up users important application files to "$USERBAKDIR"

echo " "
echo WD Smartware Backup
echo " "
pushd "$USERLOCALAPPDATA"
tar cvzf "$USERBAKDIR/WD-Smartware-files.tgz" "Western Digital" Western_Digital_Technolog
popd
pushd "$LOCALAPPDATA"
tar cvzf "$ROOTBAKDIR/WD-Smartware-files.tgz" "Western Digital" Western_Digital_Technolog
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

#echo " "
#echo Angry Birds backup
#echo " "
#echo $USERANGRYBIRDS
#cp -r "$USERANGRYBIRDS" "$USERBAKDIR\\AppData\\Roaming"

