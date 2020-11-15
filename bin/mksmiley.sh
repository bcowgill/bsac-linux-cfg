#!/bin/bash
IN=template/html/html5.html
OUT=template/html/faces-utf8.html
( head -7 $IN | perl -pne 's{Test}{UTF8 Smiley Faces}xmsg'; smiley.sh --everything | perl -pne 'chomp; $_ = qq{<p>$_</p>\n};' ; tail -2 $IN ) > $OUT
echo $OUT has been updated with every smiley known.
