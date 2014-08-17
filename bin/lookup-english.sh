#!/bin/bash
# lookup an english word for hangman type games
# lookup-english.sh .re.ter
# for hanging with friends, no vowels possible after last one given
# so we make two vars one for vowelless guesses and one for vowel including guesses
# V='aeiou'; G='delnrst'; R="[^$G]"; C="[^$V$G]"; lookup-english.sh ${R}el${C}${C}s
# filter out bad replies
# V='aeiou'; G='aenrsty'; R="[^$G]"; C="[^$V$G]"; lookup-english.sh ${R}${R}ery |  grep   -v '-' | grep -v '(' | grep -v "'" | uniq
# remove guessed letters and show a histogram of frequency for possible letters
#  V='aeiou'; export G='aensty'; R="[^$G]"; C="[^$V$G]"; lookup-english.sh ${R}${R}e${C}y |  grep -v regex | grep   -v '-' | grep -v '(' | grep -v "'" | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g'
# Show letter distribution for possible gueses
# V='aeiou'; export G='adersty'; R="[^$G]"; C="[^$V$G]"; lookup-english.sh ${R}a${R}ter | grep -v regex | uniq | perl -pne 's{[$ENV{G}]}{}g;s{([a-z])}{$1\n}g' | sort | perl -pne 's{\n}{}g' | perl -MData::Dumper -ne 'BEGIN { %L = () } END { print Dumper \%L} s{(.)}{$L{$1} += 1}xmsge' 


WORDS=`which lookup-english.sh`
WORDS=`dirname $WORDS`
WORDS="$WORDS/english"
WORDLISTS="$WORDS/english-words.txt $WORDS/english-open-word-list.txt $WORDS/american-english.txt $WORDS/british-english.txt"
[ -d $WORDS ] || mkdir -p $WORDS

if [ ! -f $WORDS/english-words.txt ]; then
   # http://www-personal.umich.edu/~jlawler/wordlist.html
   echo Fetching english words from web to $WORDS/
   wget http://www-personal.umich.edu/~jlawler/wordlist --output-document $WORDS/english-words.txt
fi
if [ ! -f $WORDS/english-open-word-list.txt ]; then
   # http://dreamsteep.com/projects/the-english-open-word-list.html
   echo Fetching open word list from web to $WORDS/
   wget http://dreamsteep.com/component/docman/doc_download/3-the-english-open-word-list-eowl.html?Itemid=30 --output-document $WORDS/eowl.zip
   pushd $WORDS
   unzip eowl.zip
   rm -rf __MACOSX
   cat EOWL-v1.1.2/LF\ Delimited\ Format/*Words.txt | sort > $WORDS/english-open-word-list.txt
   rm -rf EOWL-v1.1.2 eowl.zip
   popd
fi

if [ -z $1 ]; then
   echo Usage example: match .el..es omitting letters already guessed
   echo "L='[^delnrst]'; lookup-english.sh \${L}el\${L}\${L}es"
   echo "V='aeiou'; export G='bdenr'; L=\"[^\$G]\"; C=\"[^\$V\$G]\"; WORD=be\${L}\${L}e\${C}; lookup-english.sh \$WORD"
   exit 1
fi
echo regex: "\A $1 \b"
LOOKUP=$1 perl -ne '$squote="\x27"; next if m{[\-$squote\(]}xms; print "$_" if m{\A $ENV{LOOKUP} \b}xms' $WORDLISTS | sort | uniq

