#!/bin/bash
# Make a backup copy of users google chrome files

source setup-chrome.sh

echo " "
echo "======================================================="
echo " "
echo Backing up users google chrome files to "$USERBAKDIR/chrome"
echo " "
pushd "$USERGOOGDIR"
tar cvzf $USERBAKDIR/google-chrome-files.tgz \
 --exclude "Safe Browsing Bloom" \
 --exclude "Safe Browsing Bloom Filter 2" \
 --exclude "Default/*Cache" \
 --exclude "Default/Last Session" \
 --exclude "Default/Current Session" \
 --exclude "Default/Last Tabs" \
 --exclude "Default/Current Tabs" \
 --exclude "Default/Thumbnails" \
 --exclude "Default/*-journal" \
 --exclude "Default/JumpListIcons*" \
 --exclude "Default/Transport Security" \
 .

popd

