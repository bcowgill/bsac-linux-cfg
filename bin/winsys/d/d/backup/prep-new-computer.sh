#!/bin/bash
# Put together all files needed to move to a new computer.

source setup-win.sh

echo " "
echo "======================================================="
echo " "
echo Assembling files needed to set up a new computer

mkdir -p $NEWPC/registry
mkdir -p $NEWPC/c/cygwin/home/root
mkdir -p $NEWPC/c/cygwin/home/velda
mkdir -p "$NEWPC/c/Program Files"
mkdir -p $NEWPC/d/Sys/tools
mkdir -p $NEWPC/d/backup

# grab piriform .ini files

# grab cygwin home dirs from backup
# grab registry dumps for diffmerge textpad, media player and media monkey
# grab d/Sys tools and files
# grab d/backup scripts

pushd "$USERUSERPROFILE"
	backup_user $USERBAKDIR/c-users-files.tgz
popd


