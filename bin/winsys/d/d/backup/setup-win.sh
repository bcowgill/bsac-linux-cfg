#!/bin/bash
# set vars for Windows backups

source setup-main.sh

# WIN env settings:
# USER=root
# USERPROFILE='C:\Users\root'
# LOCALAPPDATA='C:\Users\root\AppData\Local' 

# Get User's USERPROFILE directory
USERUSERPROFILE=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$USERPROFILE"`

ROOTBAKDIR=$BACKUP/root/win
USERBAKDIR=$BACKUP/velda/win

WINSTARTMENU="$ProgramData\Microsoft\Windows\Start Menu"

mkdir -p $ROOTBAKDIR
mkdir -p $USERBAKDIR

echo ROOTBAKDIR=$ROOTBAKDIR
echo USERBAKDIR=$USERBAKDIR
echo USERUSERPROFILE=$USERUSERPROFILE
echo WINSTARTMENU=$WINSTARTMENU
