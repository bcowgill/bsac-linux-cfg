#!/bin/bash
# Put together all files needed to move to a new computer.

source setup-apps.sh

echo " "
echo "======================================================="
echo " "
echo Backing up files needed to set up a new computer

NEWPCAPPDATA="$NEWPC/c/Users/$USERNAME/AppData/Roaming/Helios/TextPad/"
USERNEWPCAPPDATA="$NEWPC/c/Users/velda/AppData/Roaming/Helios/TextPad/"

echo NEWPC=$NEWPC
echo NEWPCAPPDATA=$NEWPCAPPDATA
echo USERNEWPCAPPDATA=$USERNEWPCAPPDATA

if [ -d "$NEWPC" ]; then
   rm -rf "$NEWPC"
fi

mkdir -p "$NEWPC/c/cygwin"
mkdir -p "$NEWPC/c/Program Files"
mkdir -p "$NEWPC/d/Sys/tools"
mkdir -p "$NEWPC/d/backup/registry"
mkdir -p "$NEWPCAPPDATA"
mkdir -p "$USERNEWPCAPPDATA"

echo Backing up Piriform .ini files for to-new-computer
for prog in CCleaner Defraggler Recuva; do
   mkdir -p "$NEWPC/c/Program Files/$prog"
   cp "$PROGRAMFILES/$prog"/*.ini "$NEWPC/c/Program Files/$prog/"
done

echo Backing up cygwin home dirs for to-new-computer
cp -R "$USERCYGDIR" "$NEWPC/c/cygwin/"

echo Backing up registry dumps for to-new-computer
cp "$USERBAKDIR"/*.reg "$NEWPC/d/backup/registry"

echo Backing up d/Sys tools and d/backup tools for to-new-computer
cp -R "$DSYS/tools" "$NEWPC/d/Sys/"
cp -R "$DSYS/legacy" "$NEWPC/d/Sys/"
cp -R "$DSYS/licenses" "$NEWPC/d/Sys/"
cp -R "$DSYS/references" "$NEWPC/d/Sys/"
cp "$DSYS/cfgrec.txt" "$NEWPC/d/Sys/"
cp "$DSYS/trouble.txt" "$NEWPC/d/Sys/"
cp "$DSYS"/*.tws "$NEWPC/d/Sys/"
cp "$BACKUP"/*.bat "$NEWPC/d/backup/"
cp "$BACKUP"/*.sh "$NEWPC/d/backup/"
cp "$BACKUP"/*.xml "$NEWPC/d/backup/"
cp "$BACKUP"/*.txt "$NEWPC/d/backup/"

echo Backing up TextPad configuraion for to-new-computer
cp -R "$APPDATA/Helios/TextPad/8" "$NEWPCAPPDATA"
cp -R "$USERAPPDATA/Helios/TextPad/8" "$USERNEWPCAPPDATA"

tar cvzf "$BACKUP/to-new-computer.tgz" "$NEWPC"
