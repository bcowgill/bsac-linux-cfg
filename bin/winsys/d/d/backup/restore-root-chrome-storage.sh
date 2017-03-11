#!/bin/bash
# Copy the local backup of Google Chrome Local Storage to root account

source setup-chrome.sh

echo Restoring roots Google Local Storage from "$ROOTBAKDIR/Local Storage"
echo ROOTGOOGLOCALSTGDIR=$ROOTGOOGLOCALSTGDIR
cp -R "$ROOTBAKDIR/Local Storage" "$ROOTGOOGLOCALSTGDIR\\.." 
ls "$ROOTGOOGLOCALSTGDIR"

