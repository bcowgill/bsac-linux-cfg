#!/bin/bash
# construct a star wars fortune file
# http://bradthemad.org/tech/notes/fortune_makefile.php

FORTUNE=starwars.fortune
LIB=/usr/share/games/fortunes
rm $FORTUNE

echo "May the force be with you" >> $FORTUNE
echo '%' >> $FORTUNE

for logo in `ls *.txt`
do
	cat $logo >> $FORTUNE
	echo '%' >> $FORTUNE
done

for crawl in `ls starwars/*.txt`
do
	cat $crawl >> $FORTUNE
	echo '%' >> $FORTUNE
done

strfile -r $FORTUNE

echo "test fortune file locally"
fortune `pwd`/starwars.fortune

echo "install $FORTUNE in global dir"

sudo cp starwars.fortune $LIB/starwars
sudo cp starwars.fortune.dat $LIB/starwars.dat

echo "test fortune in global dir"
fortune starwars

exit 0
Makefile example

POSSIBLE += $(shell ls -1 | egrep -v '\.dat|README|Makefile' | sed -e 's/$$/.dat/g')

all: ${POSSIBLE}

%.dat : %
        @strfile $< $@
