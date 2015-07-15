#!/bin/bash
# guess-word.sh
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
	echo "perl -ne '\$TILES = q{evrtdhaiyw}; \$AT = 7; \$LETTERX=2; \$WORDX=2; sub score { my (\$w, \$v) = @_; \$v *= 1*\$WORDX if length(\$w) >= \$AT; \$v += (\$LETTERX-1)*\$V{substr(\$w, \$AT-1, 1)} if length(\$w) >= \$AT; return \$v; }; %V = qw( a 1 e 1 i 1 o 1 u 2   b 4 c 4 d 2 f 4 g 3 h 3 j 10 k 5 l 2 m 4 n 2 p 4 q 10 r 1 s 1 t 1 v 5 w 4 x 8 y 3 z 10 ); chomp; next if length(\$_) > 8; next if length(\$_) < 4; %C = (); if (\$_ =~ m{\A [\$TILES]+ \z}xms) { \$v = 0; \$w = \$_; s{(.)}{ ++\$C{\$1}; \$v += \$V{\$1}; qq{\$1=\$V{\$1}};}xmsge; \$score = score(\$w, \$v); print qq{\$score \$v \$w \$_ / @{[map { qq{\${_}x\$C{\$_}} } grep { \$C{\$_} > 1} keys(%C)]}\n}; } ' english/british-english.txt | sort -n | grep -v x[2-9]"
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


