#!/bin/bash
# show unicode smiley or other named character groups
# See also mksmiley.sh to make an HTML page full of smileys which you can zoom
# WINDEV tool useful on windows development machine

# ( head -7 template/html/html5.html | perl -pne 's{Test}{UTF8 Smiley Faces}xmsg'; smiley.sh --all| perl -pne 'chomp; $_ = qq{<p>$_</p>\n};' ; tail -2 template/html/html5.html ) > template/html/faces-utf8.html

option=${1:---faces}

function usage
{
	echo "
usage: $(basename $0) [--help] [--faces] [--animals] [--solar] [--all]

Display unicode smiley characters or other custom named groups of characters.

--faces  shows only smiley faces.
--animals  shows only animals and animal faces.
--solar  shows only solar system symbols. or --sun --moon --earth
--stars  shows only star symbols.
--weather  shows only weather and environmental symbols.
--all  shows all faces.
--everything  Shows every smiley option sorted.

See also mksmiley.sh to make an HTML page full of smileys which you can zoom.
"
}

ALL="all animals solar stars weather"

case $option in
	(--face|--faces)
		utf8ls.pl -3 U+2639 -56 U+1F600 ;;
	(--animal|--animals)
		utf8ls.pl -45 U+1F400 -10 U+1F638 -3 U+1F648 -1 U+1F3A0 U+1F3C7 | sort ;;
	(--solar|--sun|--moon|--earth)
		utf8ls.pl -3 U+1F30D -2 U+263D U+1F304 -13 U+1F311 -1 U+2600 U+2609 U+263C U+1F31E U+26C5 U+1F307 | sort ;;
	(--star|--stars)
		utf8ls.pl -1 U+66D ; utf8ls.pl -1 U+22C6 U+2605 U+2606 U+269D -43 U+2721 -3 U+2B50 | sort ; utf8ls.pl -2 U+1F31F -1 U+1F52F ;;
	(--weather)
		utf8ls.pl -1 U+1F525 U+263C U+2620 U+2614 -13 U+1F300 -5 U+26C4 U+2600 -2 U+2622| sort;;
	(--all)
		grep-utf8.sh \\bface | egrep -vi 'kangxi|clock|compatibility' | grep -vi 'die face' ;;
	(--everything)
		(for opt in $ALL; do smiley.sh --$opt; done) | sort | uniq;;
	(*)
		usage;;
esac

