#!/bin/bash
# modify ?random=NNNNNNNN1' in files so that IE will pick up changes made to resources included in an html page

#MATCH='random=' 
#egrep -rl "$MATCH" .
perl -i.bak -pne 'BEGIN { our $rand = rand(); } s{( (?:\?|&) random = ) [^"]* (["])}{$1$rand$2}xmsg' $*

