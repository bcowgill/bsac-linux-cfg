#!/bin/bash
# Make a backup copy of users email files

source setup-apps.sh

echo " "
echo "======================================================="
echo " "
echo Backing up users important email files to "$USERBAKDIR"
echo " "
echo Thunderbird backup
echo " "
pushd "$USERTBIRDDIR\\..\\.."
	tar cvzf $USERBAKDIR/thunderbird-files.tgz Thunderbird/Profiles
popd

