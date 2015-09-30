#!/bin/bash
# guess-word.sh
# google's list of most common english words
# git clone https://github.com/first20hours/google-10000-english.git

if [ "$WORD" == "" ] ; then
	echo usage:
	echo "# export G= guessed letters"
	echo "# L= non-guessed letters"
	echo "# C= non-guessed consonants only"
	echo "# export WORD= guess regex"
	echo 'V=aeiou; export G=bdenr; L="[^$G]"; C="[^$V$G]"; export  LC_ALL='C'; export WORD=be${L}${L}e${C}'

	echo guess-word.sh

	echo Lookup an english word for hangman type games and show letter distribution of potential guesses.
	echo For hanging with friends, no vowels possible after last one given in the puzzle.
	echo "So we make two vars one for vowelless guesses (C) and one for vowel including guesses (L)."

	echo The inverse problem, get highest scoring words
	echo "make-work.sh tiles Nxwordorletter @M"
else
	TEMP_FILE=`mktemp /tmp/lookup-english-XXXXXXXXX`
	echo G="$G"
	echo WORD="$WORD"
	lookup-english.sh $WORD > $TEMP_FILE
	grep -v '-' $TEMP_FILE | grep -v '(' | grep -v "'" | uniq

	# Show letter distribution for possible gueses
	grep -v regex $TEMP_FILE | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g' | perl -MData::Dumper -ne 'BEGIN { %L = () } END { my @Out = sort { $b - $a } map { qq{$L{$_} $_} } keys(%L); print Dumper \@Out} s{(.)}{$L{quotemeta($1)} += 1}xmsge'

	# remove guessed letters and show a histogram of frequency for possible letters
	grep -v regex $TEMP_FILE | grep -v '-' | grep -v '(' | grep -v "'" | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g'
	echo " "

	rm $TEMP_FILE
fi


