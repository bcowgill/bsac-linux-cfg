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
# USERPROFILE='C:\Users\root'
# LOCALAPPDATA='C:\Users\root\AppData\Local'
# APPDATA='C:\Users\root\AppData\Roaming'

# Get User's LOCALAPPDATA directory
USERLOCALAPPDATA=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$LOCALAPPDATA"`

# Get User's APPDATA directory
USERAPPDATA=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$APPDATA"`

# Get User's USERPROFILE directory
USERUSERPROFILE=`perl -e '$ARGV[0] =~ s{root}{velda}xms; print $ARGV[0]' "$USERPROFILE"`

USERDOCS=/cygdrive/d/d/Docs
BACKUP=/cygdrive/d/d/backup
DSYS=/cygdrive/d/d/Sys
NEWPC=$BACKUP/to-new-computer

echo BACKUP=$BACKUP
echo DSYS=$DSYS
echo NEWPC=$NEWPC
echo USERAPPDATA=$USERAPPDATA
echo USERLOCALAPPDATA=$USERLOCALAPPDATA
echo USERUSERPROFILE=$USERUSERPROFILE
echo USERDOCS=$USERDOCS
echo PATH=$PATH
