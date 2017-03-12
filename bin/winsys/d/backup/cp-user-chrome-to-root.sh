#!/bin/bash
# Copy the user account Google Chrome Local Storage to root account

source setup-chrome.sh

echo Copying users Google Local Storage to roots "$ROOTGOOGLOCALSTGDIR"
echo USERGOOGLOCALSTGDIR=$USERGOOGLOCALSTGDIR
cp -R "$USERGOOGLOCALSTGDIR" "$ROOTGOOGLOCALSTGDIR\\.."
ls "$ROOTGOOGLOCALSTGDIR"

