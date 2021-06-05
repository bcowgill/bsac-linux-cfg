#!/bin/bash
#grep-utf8.sh '(Open|Close|Initial|Final)Punctuation' | grep -v VERTICAL | grep -vE 'BRACKET|PARENTHESIS|QUOTATION|FENCE|DELIMITER|FLOOR|CEILING|MARK'

LIST=`mktemp`
TMP=`mktemp`

grep-utf8.sh '(Open|Close|Initial|Final)Punctuation|OtherSymbol' \
	| perl -ne '
		chomp;
		$_ .= qq{ [VERTICAL]} if m{(TOP|BOTTOM)\s+SQUARE}xms;
		if (m{OtherSymbol}xms)
		{
			print qq{$_\n} if (m{QUOTATION|BRACKET}xms && !m{MUSICAL|TORTOISE}xms)
		}
		else
		{
			print qq{$_\n};
		}
	' \
	> $LIST

function list-punctuation
{
	local kind omit group
	kind="$1"
	omit="$2"
	group="$3"
	if [ -z "$group" ]; then
		grep $kind $LIST | grep -vE "$omit|DOUBLE|WHITE" > $TMP
	else
	   grep $kind $LIST | grep $group | grep -vE "$omit|DOUBLE|WHITE" > $TMP
	fi
	if [ 0 == $? ]; then
		[ -z "$group" ] || echo ...$group
		cat $TMP
	fi
}

function list-punctuation-double
{
	local kind omit group
	kind="$1"
	omit="$2"
	group="$3"
	if [ -z "$group" ]; then
	   grep $kind $LIST | grep DOUBLE | grep -vE "$omit|WHITE" > $TMP
	else
		grep $kind $LIST | grep DOUBLE | grep $group | grep -vE "$omit|WHITE" > $TMP
	fi
	if [ 0 == $? ]; then
		echo ...DOUBLE $group
		cat $TMP
	fi

	if [ -z "$group" ]; then
	   grep $kind $LIST | grep WHITE | grep -vE "$omit|DOUBLE" > $TMP
	else
		grep $kind $LIST | grep WHITE | grep $group | grep -vE "$omit|DOUBLE" > $TMP
	fi
	if [ 0 == $? ]; then
		echo ...WHITE $group
		cat $TMP
	fi
}

function group-punctuation
{
	local kind omit group
	kind="$1"
	omit="$2"
	group="$3"
	list-punctuation $kind "$omit|DOUBLE|WHITE" $group
	list-punctuation-double $kind "$omit" $group
}

NOVERTICAL=VERTICAL
for kind in QUOTATION PARENTHESIS BRACKET CEILING FLOOR FENCE DELIMITER MARK VERTICAL
do
# SQUARE CURLY ANGLE
	perl -e "print qq{\n}"
	echo $kind
	if [ $kind == MARK ]; then
		NOVERTICAL="VERTICAL|QUOTATION"
	fi
	if [ $kind == VERTICAL ]; then
		NOVERTICAL=XyZzY
	fi

	list-punctuation $kind "$NOVERTICAL|SQUARE|CORNER|CURLY|ANGLE"
	list-punctuation-double $kind "$NOVERTICAL|SQUARE|CORNER|CURLY|ANGLE"

	group-punctuation $kind "$NOVERTICAL|CORNER|CURLY|ANGLE" SQUARE
	group-punctuation $kind "$NOVERTICAL|SQUARE|CURLY|ANGLE" CORNER
	group-punctuation $kind "$NOVERTICAL|SQUARE|CORNER|ANGLE" CURLY
	group-punctuation $kind "$NOVERTICAL|SQUARE|CORNER|CURLY" ANGLE
done

rm $LIST
rm $TMP
