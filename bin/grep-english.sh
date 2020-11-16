#!/bin/bash
# grep for an english word
# WINDEV tool useful on windows development machine
egrep $1 ~/bin/english/*english*.txt | perl -pne 's{^.+:}{}xmsg' | sort | uniq
