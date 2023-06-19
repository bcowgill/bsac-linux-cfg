#!/bin/bash
# Tool to fix javascript code by importing a symbol from a library and making a text replacement.
# NOTE: does not work well if any files have spaces in their names.
# Use SPACES var to configure them to be filtered out in getFiles or getFilesE if you have any.

FILE_LIST="$*"

TEST_PLANS='\.test\.js'
SPACES='DIR WITH SPACES'

function getFiles {
	local matcher
	matcher="$1"
	if [ ! -z "$STOP" ]; then
		echo Skipping "$matcher" replacements 1>&2
	else
		if [ -z "$FILE_LIST" ]; then
			git grep -l "matcher" # | grep -v "$SPACES"
		else
			$FILE_LIST
		fi
	fi
}

function getFilesE {
	local matcher
	matcher="$1"
	if [ ! -z "$STOP" ]; then
		echo Skipping "$matcher" replacements 1>&2
	else
		if [ -z "$FILE_LIST" ]; then
			git grep -lE "matcher" # | grep -v "$SPACES"
		else
			$FILE_LIST
		fi
	fi
}

function addImportSymbol {
	local symbol import minus file
	symbol="$1"
	import="$2"
	minus="$3"
	file="$4"
	echo "$file: ADDING import { $symbol } from \"../$import\";"
	FN=$file \
	MN=$minus \
	SM="$symbol" \
	IM="$import" \
	perl -i -pne '
		my $depth = $ENV{FN} =~ tr[/][/];
		my $path = "../" x ($depth - $ENV{MN});
		if ($. == 1)
		{
			$_ = qq{import { $ENV{SM} } from "$ENV{IM}";\n$_};
		}
	' $file
}

function addImportDefault {
	local symbol import minus file
	symbol="$1"
	import="$2"
	minus="$3"
	file="$4"
	echo "$file: ADDING import $symbol from \"../$import\";"
	FN=$file \
	MN=$minus \
	SM="$symbol" \
	IM="$import" \
	perl -i -pne '
		my $depth = $ENV{FN} =~ tr[/][/];
		my $path = "../" x ($depth - $ENV{MN});
		if ($. == 1)
		{
			$_ = qq{import $ENV{SM} from "$ENV{IM}";\n$_};
		}
	' $file
}

function updateImportSymbol {
	local symbol import file
	symbol="$1"
	import="$2"
	file="$3"
	echo "$file: UPDATING import { $symbol } from \"../$import\";"
	FN=$file \
	SM="$symbol" \
	IM="$import" \
	perl -i -pne '
		my $depth = $ENV{FN} =~ tr[/][/];
		$_ =~ s{(import.+\}.+$ENV{IM})}{$1 $ENV{SM},$2}xms;
	' $file
}

function updateImportDefault {
	local symbol import file
	symbol="$1"
	import="$2"
	file="$3"
	echo "$file: UPDATING import $symbol, { ... } from \"../$import\";"
	FN=$file \
	SM="$symbol" \
	IM="$import" \
	perl -i -pne '
		my $depth = $ENV{FN} =~ tr[/][/];
		$_ =~ s{(import).+$ENV{IM})}{$1 $ENV{SM},$2}xms;
	' $file
}

function checkAddImportSymbol {
	local symbol import minus file
	symbol="$1"
	import="$2"
	minus="$3"
	file="$4"
	if [ "0" != `diff $file $file.bak | wc -l` ]; then
		if [ "0" != `grep -E "import.+\\b$symbol\\b.+$import" $file | wc -l` ]; then
			echo $file: DONE
		else
			if [ "0" != `grep -E "import.+$import" $file | wc -l` ]; then
				updateImportSymbol "$symbol" "$import" "$file"
			else
				addImportSymbol "$symbol" "$import" "$minus" "$file"
			fi
		fi
	fi
	rm $file.bak
}

function checkAddImportDefault {
	local symbol import minus file
	symbol="$1"
	import="$2"
	minus="$3"
	file="$4"
	if [ "0" != `diff $file $file.bak | wc -l` ]; then
		if [ "0" != `grep -E "import.+\\b$symbol\\b.+$import" $file | wc -l` ]; then
			echo $file: DONE
		else
			if [ "0" != `grep -E "import.+$import" $file | wc -l` ]; then
				updateImportDefault "$symbol" "$import" "$file"
			else
				addImportDefault "$symbol" "$import" "$minus" "$file"
			fi
		fi
	fi
	rm $file.bak
}

#===========================================================================

#set -x
FILES=`getFilesE 'expect\(asFragment\)'`
echo 00 FILES=$FILES
[ ! -z "$FILES" ] && \
	perl -i.bak -pne '
		s{(expect\()\s*(asFragment)\s*\)}{$1$2())}xmsg;
	' $FILES

FILES=`getFilesE 'getBy.+\.toBeInTheDocument'`
echo 01 FILES=$FILES
[ ! -z "$FILES" ] && \
	perl -i.bak -pne '
		s{getBy(.+\.toBeInTheDocument)}{queryBy$1)}xmsg;
	' $FILES

DEPTH=1
IMPORT=utils/functions
SYMBOL=givesUndefined
FILES=`getFilesE '\(\)\s*=>\s*(undefined|\{\s*\})' | grep -vE "$IMPORT\\.js|$TEST_PLANS"`
echo 1 FILES=$FILES
[ ! -z "$FILES" ] && SM="$SYMBOL" \
	perl -i.bak -pne '
		s{\(\)\s*=>\s*(undefined|\{\s*\})}{$ENV{SM}}xmsg
	' $FILES
for f in $FILES
do
	checkAddImportSymbol "$SYMBOL" "$IMPORT" $DEPTH $f
done

#set +x
#STOP=1

DEPTH=1
IMPORT=utils/functions
SYMBOL=givesNull
FILES=`getFilesE '\(\)\s*=>\s*null' | grep -vE "$IMPORT\\.js|$TEST_PLANS"`
echo 2 FILES=$FILES
[ ! -z "$FILES" ] && SM="$SYMBOL" \
	perl -i.bak -pne '
		s{\(\)\s*=>\s*null}{$ENV{SM}}xmsg
	' $FILES
for f in $FILES
do
	checkAddImportSymbol "$SYMBOL" "$IMPORT" $DEPTH $f
done

DEPTH=1
IMPORT=utils/functions
SYMBOL=givesFalse
FILES=`getFilesE '\(\)\s*=>\s*false' | grep -vE "$IMPORT\\.js|$TEST_PLANS"`
echo 3 FILES=$FILES
[ ! -z "$FILES" ] && SM="$SYMBOL" \
	perl -i.bak -pne '
		s{\(\)\s*=>\s*false}{$ENV{SM}}xmsg
	' $FILES
for f in $FILES
do
	checkAddImportSymbol "$SYMBOL" "$IMPORT" $DEPTH $f
done

DEPTH=1
IMPORT=utils/functions
SYMBOL=givesTrue
FILES=`getFilesE '\(\)\s*=>\s*true' | grep -vE "$IMPORT\\.js|$TEST_PLANS"`
echo 4 FILES=$FILES
[ ! -z "$FILES" ] && SM="$SYMBOL" \
	perl -i.bak -pne '
		s{\(\)\s*=>\s*true}{$ENV{SM}}xmsg
	' $FILES
for f in $FILES
do
	checkAddImportSymbol "$SYMBOL" "$IMPORT" $DEPTH $f
done

DEPTH=1
IMPORT=utils/functions
SYMBOL=givesEmpty
FILES=`getFilesE '\(\)\s*=>\s*""' | grep -vE "$IMPORT\\.js|$TEST_PLANS"`
echo 5 FILES=$FILES
[ ! -z "$FILES" ] && SM="$SYMBOL" \
	perl -i.bak -pne '
		s{\(\)\s*=>\s*""}{$ENV{SM}}xmsg
	' $FILES
for f in $FILES
do
	checkAddImportSymbol "$SYMBOL" "$IMPORT" $DEPTH $f
done


