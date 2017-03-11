#!/bin/bash
# set main variables

echo " "
echo " "

if [ "$USERNAME" != "root" ]; then
   echo You must run this as the root administrator.
   echo USERNAME="$USERNAME"
   exit 1
fi

PATH=/usr/local/bin:/usr/bin:$PATH

# WIN env settings:
# USERNAME=root
# LOCALAPPDATA='C:\Users\root\AppData\Local' 
# APPDATA='C:\Users\root\AppData\Roaming'

# Get User's LOCALAPPDATA directory
USERLOCALAPPDATA=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$LOCALAPPDATA"`

# Get User's APPDATA directory
USERAPPDATA=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$APPDATA"`

# Get User's Documents and Settings Application Data directory
USERDOCSETAPPDATA="C:\Documents and Settings\velda\Local Settings\Application Data"

USERDOCS=/cygdrive/d/d/Docs
BACKUP=/cygdrive/d/d/backup
NEWPC=/$BACKUP/to-new-computer

echo BACKUP=$BACKUP
echo NEWPC=$NEWPC
echo USERAPPDATA=$USERAPPDATA
echo USERLOCALAPPDATA=$USERLOCALAPPDATA
echo USERDOCSETAPPDATA=$USERDOCSETAPPDATA
echo USERDOCS=$USERDOCS
echo PATH=$PATH

