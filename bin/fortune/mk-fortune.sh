#!/bin/bash
# construct fortune files
# http://bradthemad.org/tech/notes/fortune_makefile.php

LIB=/usr/share/games/fortunes
FORTUNES=`ls *.fortune`

for file in $FORTUNES
do
	if grep CRLF $file > /dev/null; then
		echo OK file has unix newlines
	else
		dos2unix $file
	fi
	strfile -r $file
	echo "test fortune file locally"
	fortune `pwd`/$file
	BASE=`basename $file .fortune`
	echo "install $file in global dir"
	sudo cp $file $LIB/$BASE
	sudo cp $file.dat $LIB/$BASE.dat
	echo "test fortune in global dir"
	fortune $BASE
done

exit 0
Makefile example

POSSIBLE += $(shell ls -1 | egrep -v '\.dat|README|Makefile' | sed -e 's/$$/.dat/g')

all: ${POSSIBLE}

%.dat : %
        @strfile $< $@
