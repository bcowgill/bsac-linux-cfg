#!/bin/bash
# prepare other word list files based on the master ones present

FILES=*.txt

for dir in hanging atoz apos hyphen number abbrev non-az alpha non-alpha alpha-non-az
do
	mkdir $dir 2> /dev/null
done

DIR=hyphen
echo generate $DIR word lists
for file in $FILES
do
	egrep -- - $file > $DIR/$file
done

DIR=apos
echo generate $DIR word lists
for file in $FILES
do
	egrep "'" $file > $DIR/$file
done

DIR=number
echo generate $DIR word lists
for file in $FILES
do
	egrep [0-9] $file > $DIR/$file
done

DIR=abbrev
echo generate $DIR word lists
for file in $FILES
do
	egrep \\. $file > $DIR/$file
done

DIR=non-az
echo generate $DIR word lists
for file in $FILES
do
	egrep '[^a-zA-Z\n]' $file > $DIR/$file
done

DIR=non-alpha
echo generate $DIR word lists
for file in $FILES
do
	egrep -v '^[[:alpha:]]*$' $file > $DIR/$file
done

# egrep manpage
# Finally,  certain  named  classes  of  characters  are predefined within bracket expressions, as follows.
# Their names are self explanatory, and they are [:alnum:],  [:alpha:],  [:cntrl:],  [:digit:],  [:graph:],
# [:lower:],  [:print:],  [:punct:],  [:space:], [:upper:], and [:xdigit:].  For example, [[:alnum:]] means
# the character class of numbers and letters in the current locale. In the C locale and ASCII character set
# encoding,  this is the same as [0-9A-Za-z].  (Note that the brackets in these class names are part of the
# symbolic names, and must be included in addition to the  brackets  delimiting  the  bracket  expression.)
# Most meta-characters lose their special meaning inside bracket expressions.  To include a literal ] place
# it first in the list.  Similarly, to include a literal ^  place  it  anywhere  but  first.   Finally,  to
# include a literal - place it last.

DIR=alpha
echo generate $DIR word lists
for file in $FILES
do
	egrep -v "[[:punct:][:digit:]]" $file > $DIR/$file
done

DIR=alpha-non-az
echo generate $DIR word lists
for file in $FILES
do
	egrep -v "[[:punct:][:digit:]]" $file | egrep '[^a-zA-Z\n]'> $DIR/$file
done

DIR=atoz
echo generate $DIR word lists
for file in $FILES
do
	anglicise.pl $file | sort | uniq > $DIR/$file
done

DIR=hanging
echo generate $DIR word lists
for file in $FILES
do
	egrep -v "[[:punct:][:digit:]]" $file | anglicise.pl \
	| perl -ne 'chomp; print "$_\n" if length($_) >= 4 && length($_) <= 8' \
	| sort | uniq > $DIR/$file
done

echo remove empty files
find . -size 0 -type f -name '*.txt' -delete
