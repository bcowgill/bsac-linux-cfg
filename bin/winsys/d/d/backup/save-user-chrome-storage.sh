#!/bin/bash
# Copy the user account Google Chrome Local Storage to a local backup location

source setup-chrome.sh

echo Saving users Google Local Storage to "$USERBAKDIR"
echo USERGOOGLOCALSTGDIR=$USERGOOGLOCALSTGDIR
rm -rf "$USERBAKDIR/Local Storage"
cp -R "$USERGOOGLOCALSTGDIR" "$USERBAKDIR"
ls "$USERBAKDIR/Local Storage"

