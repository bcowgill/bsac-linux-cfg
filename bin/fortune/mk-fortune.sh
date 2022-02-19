#!/bin/bash
# construct fortune files
# http://bradthemad.org/tech/notes/fortune_makefile.php

LIB=/usr/share/games/fortunes
if [ ! -d $LIB ]; then
	LIB=/usr/local/Cellar/fortune/9708/share/games/fortunes
fi

FORTUNES=`ls *.fortune`

[ -e fortune.failures.lst ] && rm fortune.failures.lst
touch fortune.failures.lst

function test_fortune_output
{
	local file FILE count SUCCESS FAILS
	file="$1"
	for count in 5 4 3 2 1; do
		if [ 0 == `fortune "$file" | wc -l` ]; then
			FAILS=1
		else
			SUCCESS=1
		fi
	done
	FILE=`fortune -f "$file" 2>&1`
	if [ -z $SUCCESS ]; then
		echo "NOT OK fortune $FILE shows no output ever" | tee -a fortune.failures.lst
	else
		echo OK fortune $file shows something at least some of the time.
		if [ ! -z $FAILS ]; then
			echo "NOT COMPLETELY OK fortune $FILE shows no output sometimes" | tee -a fortune.failures.lst
		fi
	fi
}

function test_fortune
{
	local file FILE
	file="$1"
	if fortune "$file" > /dev/null; then
		echo OK fortune $file returns zero
		test_fortune_output "$file"
	else
		FILE=`fortune -f "$file" 2>&1`
		echo "NOT OK fortune $FILE returns non-zero" | tee -a fortune.failures.lst
	fi
}

for file in $FORTUNES
do
	if grep CRLF $file > /dev/null; then
		echo OK file has unix newlines
	else
		dos2unix $file
	fi
	strfile -r $file
	test_fortune `pwd`/$file
	BASE=`basename $file .fortune`
	echo "install $file in global dir"
	sudo cp $file $LIB/$BASE
	sudo cp $file.dat $LIB/$BASE.dat
	test_fortune $BASE
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
cat fortune.failures.lst
rm fortune.failures.lst

exit 0
Makefile example

POSSIBLE += $(shell ls -1 | egrep -v '\.dat|README|Makefile' | sed -e 's/$$/.dat/g')

all: ${POSSIBLE}

%.dat : %
        @strfile $< $@
