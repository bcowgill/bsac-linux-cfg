#!/bin/bash
# Take a snapshot of all files on C drive.
# Run cygwin as administrator before running this
# Breaks into dir list, file list, unique file names and extension lists.

CDIR=/cygdrive/c
SNAP=/cygdrive/d/d/Sys/snapshots

# dictionary sort
export LC_ALL='C'
SORT=-d

PREFIX=$1
if [ "x" == "x$PREFIX" ]; then
   PREFIX=all
fi

FILE=$PREFIX-files-c-drive.txt
DIRFILE=$PREFIX-dirs-c-drive.txt
NAMEFILE=$PREFIX-filenames-c-drive.txt
EXTFILE=$PREFIX-file-extensions-c-drive.txt

pushd $CDIR
find . -type d | tee $SNAP/all-dirs-unsorted.txt
find . -type f | tee $SNAP/all-files-unsorted.txt
sort $SORT < $SNAP/all-dirs-unsorted.txt | tee $SNAP/$DIRFILE
sort $SORT < $SNAP/all-files-unsorted.txt | tee $SNAP/$FILE
rm $SNAP/all-files-unsorted.txt $SNAP/all-dirs-unsorted.txt

perl -pne 's{\A .+ / ([^/]+) \z}{$1}xmsg' $SNAP/$FILE | sort $SORT| uniq > $SNAP/$NAMEFILE
perl -ne 'chomp; next if m{\A \.}xms; print if s{\A (.+ \.) (.+) \z}{$2\n}xmsg' $SNAP/$NAMEFILE | sort $SORT | uniq > $SNAP/$EXTFILE

popd
echo Saved a scan of all files on C drive to $SNAP/$FILE
echo Also $DIRFILE $NAMEFILE $EXTFILE

