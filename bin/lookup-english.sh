#!/bin/bash
# lookup an english word for hangman type games
# see also guess-word.sh

WORDS=`which lookup-english.sh`
WORDS=`dirname $WORDS`
WORDS="$WORDS/english/hanging"
WORDLISTS="
	$WORDS/english-words.txt
	$WORDS/english-open-word-list.txt
	$WORDS/american-english.txt
	$WORDS/british-english.txt
	$WORDS/custom-words.txt
"
GAMELIST=$WORDS/game-only.txt

[ -d $WORDS ] || mkdir -p $WORDS

if [ ! -f $WORDS/english-words.txt ]; then
	# http://www-personal.umich.edu/~jlawler/wordlist.html
	echo Fetching english words from web to $WORDS/../
	wget http://www-personal.umich.edu/~jlawler/wordlist --output-document $WORDS/../english-words.txt
fi
if [ ! -f $WORDS/english-open-word-list.txt ]; then
	# http://dreamsteep.com/projects/the-english-open-word-list.html
	echo Fetching open word list from web to $WORDS/../
	wget http://dreamsteep.com/component/docman/doc_download/3-the-english-open-word-list-eowl.html?Itemid=30 --output-document $WORDS/../eowl.zip
	pushd $WORDS/../
	unzip eowl.zip
	rm -rf __MACOSX
	cat EOWL-v1.1.2/LF\ Delimited\ Format/*Words.txt | sort > $WORDS/../english-open-word-list.txt
	rm -rf EOWL-v1.1.2 eowl.zip
	popd
fi
if [ ! -f $WORDS/english-words.txt ]; then
	pushd $WORDS/../
	./prepare.sh
	popd
fi

if [ -z $1 ]; then
	echo Usage example: match .el..es omitting letters already guessed
	echo "L='[^delnrst]'; lookup-english.sh \${L}el\${L}\${L}es"
	echo "V='aeiou'; export G='bdenr'; L=\"[^\$G]\"; C=\"[^\$V\$G]\"; WORD=be\${L}\${L}e\${C}; lookup-english.sh \$WORD"
	if [ -f $GAMELIST ]; then
		echo WARNING: $GAMELIST is the only word list that will be looked at.  Delete file if you want to use all english words.
	else
		echo If you create a file $GAMELIST it will be the only word list checked.
	fi
	exit 1
fi

if [ ! -f $GAMELIST ]; then
	GAMELIST="$WORDLISTS"
fi

echo regex: "\A $1 \b"
#echo lookup: $1
#echo WORDLISTS: $GAMELIST
LOOKUP=$1 perl -ne '$squote="\x27"; tr[A-Z][a-z]; next if m{[\-$squote\(]}xms; print "$_" if m{\A $ENV{LOOKUP} \b}xms' $GAMELIST | sort | uniq

