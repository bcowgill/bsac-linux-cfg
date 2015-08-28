#!/bin/bash
# construct a star wars fortune file
# http://bradthemad.org/tech/notes/fortune_makefile.php

FORTUNE=starwars.fortune
rm $FORTUNE
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

echo "May the force be with you" >> $FORTUNE

strfile $FORTUNE $FORTUNE.dat
# install it in global dir

exit 0
Makefile example

POSSIBLE += $(shell ls -1 | egrep -v '\.dat|README|Makefile' | sed -e 's/$$/.dat/g')

all: ${POSSIBLE}

%.dat : %
        @strfile $< $@
