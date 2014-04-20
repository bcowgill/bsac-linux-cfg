#!/bin/bash
# lookup an english word for hangman type games
# lookup-english.sh .re.ter
# R='[^delnrst]'; lookup-english.sh ${R}el${R}${R}es

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
echo regex: "\A $1 \b"
LOOKUP=$1 perl -ne 'print "$_" if m{\A $ENV{LOOKUP} \b}xms' $WORDLISTS | sort | uniq

