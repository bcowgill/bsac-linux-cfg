#!/bin/bash
# backup C: files to network home for safe keeping

WHOM=lloyds
TO=/o/cdrive/d/home
DEL=$TO/../DELETEME

if [ "$COMPANY" == "$WHOM" ]; then
	echo Saving $COMPANY config to network $TO for safe keeping
else
	echo This script is only for use on $WHOM computer.
	exit 1
fi

mv $TO $DEL && mkdir -p $TO/workspace $TO/bin

echo Backing up to $TO
cp -r .[a-zA-Z]* $TO
cp [a-zA-Z]* $TO

save-lloyds.sh

echo Updating ~/files.lst
find . -depth -type f > ~/files.lst &

DIR=workspace; echo Backing up $DIR        && cp $DIR/* $TO/$DIR
DIR=bin;       echo Backing up $DIR deeply && cp -r $DIR/ $TO/

echo Deleting old backup.
rm -rf $DEL &

echo " "
echo TO=$TO
ls -a $TO

