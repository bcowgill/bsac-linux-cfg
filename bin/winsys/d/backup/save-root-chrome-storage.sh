#!/bin/bash
# Copy the root account Google Chrome Local Storage to a local backup location

source setup-chrome.sh

echo Saving roots Google Local Storage to "$ROOTBAKDIR"
echo ROOTGOOGLOCALSTGDIR=$ROOTGOOGLOCALSTGDIR
rm -rf "$ROOTBAKDIR/Local Storage"
cp -R "$ROOTGOOGLOCALSTGDIR" "$ROOTBAKDIR"
ls "$ROOTBAKDIR/Local Storage"

