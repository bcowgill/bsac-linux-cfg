#!/bin/bash
# show a sample of unicode alphabets from mathematics

A=" "
N=-10

if [ ! -z $1 ]; then
A=$1
N=$1
fi

echo monospace serif
utf8ls.pl $A U+1D68A U+1D670 $N U+1D7F6
echo sans-serif
utf8ls.pl $A U+1D5BA U+1D5A0 $N U+1D7E2

echo italic serif
utf8ls.pl $A U+1D44E U+1D434
echo italic bold serif
utf8ls.pl $A U+1D482 U+1D468
echo italic sans-serif
utf8ls.pl $A U+1D622 U+1D608
echo italic bold sans-serif
utf8ls.pl $A U+1D656 U+1D63C

echo bold serif
utf8ls.pl $A U+1D41A U+1D400 $N U+1D7CE
echo bold sans-serif
utf8ls.pl $A U+1D5EE U+1D5D4 $N U+1D7EC
echo double-strike serif
utf8ls.pl $A U+1D552 U+1D538 $N U+1D7D8

echo script
utf8ls.pl $A U+1D4EA U+1D4D0
echo italic script
utf8ls.pl $A U+1D4B6 U+1D49C

echo gothic
utf8ls.pl $A U+1D51E U+1D504
echo gothic bold
utf8ls.pl $A U+1D586 U+1D56C
