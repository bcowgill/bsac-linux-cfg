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
	#echo "test fortune file locally"
	#fortune `pwd`/$file
	BASE=`basename $file .fortune`
	echo "install $file in global dir"
	sudo cp $file $LIB/$BASE
	sudo cp $file.dat $LIB/$BASE.dat
	#echo "test fortune in global dir"
	#fortune $BASE
done

touch known-fortunes.lst
ls *.fortune | perl -pne 's{\.fortune}{}xmsg; s{\A}{\t\t}xmsg;' > all-fortunes.lst 

pushd starwars && ./mk-fortune-starwars.sh && popd

cmp known-fortunes.lst all-fortunes.lst || (\
	cp all-fortunes.lst known-fortunes.lst; \
	echo "# New fortune files exist, amend the MIX setting at top of script..." >> ~/bin/random-text.sh; \
	cat all-fortunes.lst >> ~/bin/random-text.sh; \
	vim ~/bin/random-text.sh \
)
rm all-fortunes.lst

exit 0
Makefile example

POSSIBLE += $(shell ls -1 | egrep -v '\.dat|README|Makefile' | sed -e 's/$$/.dat/g')

all: ${POSSIBLE}

%.dat : %
        @strfile $< $@
