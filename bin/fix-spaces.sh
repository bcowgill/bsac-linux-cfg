#!/bin/bash
# fix up spacing in a file

INDENT_TAB=0
INDENT=4
INPLACE=-i.bak
#INPLACE=""

if [ -z "$1" ]; then
   echo Usage: $0 file ...
   echo " "
   echo Fix up trailing space in files and adjust mixed space/tabs for indentation.
   echo Flag INDENT_TAB=$(INDENT_TAB:-0) if 1 will indent with tab characters.
   echo Flag INDENT=$INDENT sets number of spaces to a tab stop.
   [ -z "$INPLACE" ] || echo Flag INPLACE causes changes to be written back to original file
   exit 1
fi

if [ "${INDENT_TAB:-0}" == 1 ]; then
   echo THIS IS NOT WORKING
   exit 1
   perl $INPLACE -pne 'BEGIN { our $indent = shift; our $tabstop = " " x $indent; }; s{\s+ \z}{\n}xmsg; while (s{\A ($tabstop)}{ "\t" x (length($1)/$indent) }xmsge) { last unless length($1); } ;' $INDENT $*
else
   perl $INPLACE -pne 'BEGIN { our $indent = shift; }; s{\s+ \z}{\n}xmsg; while (s{\A (\s*?) (\t+)}{$1 . (" " x ($indent * length($2))) }xmsge) {};' $INDENT $*
fi

