#!/bin/bash
# grep for an english word
egrep $1 ~/bin/english/*english*.txt | perl -pne 's{^.+:}{}xmsg' | sort | uniq
