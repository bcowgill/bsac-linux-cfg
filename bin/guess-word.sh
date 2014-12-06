#!/bin/bash
# guess-word.sh
if [ "$WORD" == "" ] ; then
	echo usage:
	echo "# export G= guessed letters"
	echo "# L= non-guessed letters"
	echo "# C= non-guessed consonants only"
	echo "# export WORD= guess regex"
	echo 'V=aeiou; export G=bdenr; L="[^$G]"; C="[^$V$G]"; export WORD=be${L}${L}e${C}'

	echo guess-word.sh

	echo Lookup an english word for hangman type games and show letter distribution of potential guesses.
	echo For hanging with friends, no vowels possible after last one given in the puzzle.
	echo "So we make two vars one for vowelless guesses (C) and one for vowel including guesses (L)."

	echo The inverse problem, get highest scoring words
	echo "perl -ne 'sub score { my (\$w, \$v) = @_; \$v *= 2 if length(\$w) >= 7; return \$v; }; \$TILES = q{evrtdhaiyw}; %V = qw( a 1 e 1 i 1   d 2 h 3 r 1 t 1 v 5 w 4 y 3 ); chomp; next if length(\$_) > 8; next if length(\$_) < 4; if (\$_ =~ m{\A [\$TILES]+ \z}xms) { \$v = 0; \$w = \$_; s{(.)}{\$v += \$V{\$1}; qq{\$1 \$V{\$1}   };}xmsge; \$score = score(\$w, \$v); print qq{\$score \$v \$w \$_\n}; } ' english/british-english.txt | sort -n"

else
	TEMP_FILE=`mktemp /tmp/lookup-english-XXXXXXXXX`
    echo G="$G"
    echo WORD="$WORD"
	lookup-english.sh $WORD > $TEMP_FILE
    grep -v '-' $TEMP_FILE | grep -v '(' | grep -v "'" | uniq

    # Show letter distribution for possible gueses
    grep -v regex $TEMP_FILE | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g' | perl -MData::Dumper -ne 'BEGIN { %L = () } END { print Dumper \%L} s{(.)}{$L{$1} += 1}xmsge' 

    # remove guessed letters and show a histogram of frequency for possible letters
    grep -v regex $TEMP_FILE | grep -v '-' | grep -v '(' | grep -v "'" | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g'

	rm $TEMP_FILE
fi


