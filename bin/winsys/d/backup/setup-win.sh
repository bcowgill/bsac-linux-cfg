#!/bin/bash
# set vars for Windows backups

source setup-main.sh

# WIN env settings:
# USER=root
# USERPROFILE='C:\Users\root'
# LOCALAPPDATA='C:\Users\root\AppData\Local'

ROOTBAKDIR=$BACKUP/root/win
USERBAKDIR=$BACKUP/velda/win

WINSTARTMENU="$ProgramData\Microsoft\Windows\Start Menu"

mkdir -p $ROOTBAKDIR
mkdir -p $USERBAKDIR

echo ROOTBAKDIR=$ROOTBAKDIR
echo USERBAKDIR=$USERBAKDIR
echo WINSTARTMENU=$WINSTARTMENU
