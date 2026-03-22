#!/bin/bash

CH=${1:-a5f8}
#CH=`grep-utf8.sh alpha | head -1 | perl -pne 's{\A.+U\+(\S+).+\z}{$1}xms'`

# define the heading text and html entity for same...
H1=`utf8ls.pl U+$CH | head -1 | perl -pne 's{\A.+(\[[^\]]+\])\s+(.+?)\s*\z}{$2 $1}xms'`
H1="U+$CH: $H1"
EN="&#x$CH;"
echo Update unicode-char.html with:
echo $EN $H1

# substitute the heading and entity into this html in the right place.
EN="$EN" H1="$H1" perl -i -pne 's{<(title|h1)>.+</\1>}{<$1>$ENV{H1}</$1>}xmsg; s{<(article)>.+</\1>}{<$1>$ENV{EN}</$1>}xmsg;' unicode-char.html
