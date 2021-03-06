#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# fix up spacing in a file
# WINDEV tool useful on windows development machine

# TODO make these flags accessible on command line
# See also fix-spaces.sh, fix-tabs.sh, strip-newline.sh, strip-whitespace.sh
INDENT_TAB=${INDENT_TAB:-1}
INDENT=${INDENT:-4}
INPLACE=-i.bak
#INPLACE=""

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) file ...

Fix up trailing space in files and adjust mixed space/tabs for indentation.
Flag INDENT_TAB=${INDENT_TAB:-0} if =1 will indent with tab characters.
Flag INDENT=$INDENT sets number of spaces to a tab stop.

See also fix-tabs.sh
"
[ -z "$INPLACE" ] || echo Flag INPLACE causes changes to be written back to original file.
	exit 1
fi

if [ "${INDENT_TAB:-0}" == 1 ]; then
	perl $INPLACE -pne 'BEGIN { our $indent = shift; our $tabstop = "\\ {$indent}";  print "indent[$indent]\ntabstop[$tabstop]\n" if (0); }; print "i[$_]\n" if (0); s{\s+ \z}{\n}xmsg; print "t[$_]\n" if (0); while (s{\A (\t*) ($tabstop+)}{ $1 . ("\t" x (length($2)/$indent)) }xmsge) { print "t2[$_]\n" if (0); } ;' $INDENT $*
else
	perl $INPLACE -pne 'BEGIN { our $indent = shift; }; s{\s+ \z}{\n}xmsg; while (s{\A (\s*?) (\t+)}{$1 . (" " x ($indent * length($2))) }xmsge) {};' $INDENT $*
fi

