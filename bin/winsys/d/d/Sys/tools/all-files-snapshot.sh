#!/bin/bash
# Take a snapshot of all files on C drive.
# Run cygwin as administrator before running this

# dictionary sort
export LC_ALL='C'
SORT=-d

PREFIX=$1
DIR=/cygdrive/d/d/Sys/snapshots
if [ "x" == "x$PREFIX" ]; then
   PREFIX=all
fi

FILE=$PREFIX-files-c-drive.txt
DIRFILE=$PREFIX-dirs-c-drive.txt
NAMEFILE=$PREFIX-filenames-c-drive.txt
EXTFILE=$PREFIX-file-extensions-c-drive.txt

pushd /cygdrive/c
find . -type d | tee $DIR/all-dirs-unsorted.txt
find . -type f | tee $DIR/all-files-unsorted.txt
sort $SORT < $DIR/all-dirs-unsorted.txt | tee $DIR/$FILE
sort $SORT < $DIR/all-files-unsorted.txt | tee $DIR/$DIRFILE
rm $DIR/all-files-unsorted.txt $DIR/all-dirs-unsorted.txt

perl -pne 's{\A .+ / ([^/]+) \z}{$1}xmsg' $DIR/$FILE | sort $SORT| uniq > $DIR/$NAMEFILE
perl -ne 'chomp; next if m{\A \.}xms; print if s{\A (.+ \.) (.+) \z}{$2\n}xmsg' $DIR/all-filenames.txt | sort $SORT | uniq > $DIR/$EXTFILE

popd
echo Saved a scan of all files on C drive to $DIR/$FILE
echo Also $DIRFILE $NAMEFILE $EXTFILE
