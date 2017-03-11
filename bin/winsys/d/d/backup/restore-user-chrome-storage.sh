#!/bin/bash
# Restore the local backup of Google Chrome Local Storage to user account

source setup-chrome.sh

echo Restoring users Google Local Storage from "$USERBAKDIR/Local Storage"
echo USERGOOGLOCALSTGDIR=$USERGOOGLOCALSTGDIR
cp -R "$USERBAKDIR/Local Storage" "$USERGOOGLOCALSTGDIR\\.." 
ls "$USERGOOGLOCALSTGDIR"

