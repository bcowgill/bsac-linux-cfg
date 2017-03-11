#!/bin/bash
# Make a backup copy of users picasa files

source setup-apps.sh

echo " "
echo "======================================================="
echo " "
echo Backing up users important picasa files to "$USERBAKDIR"

echo " "
echo Google Picasa backup
echo " "
pushd "$USERPICASADIR\\.."
tar cvzf $USERBAKDIR/picasa-files.tgz Picasa2 Picasa2Albums
popd

