#!/bin/bash
# fix up Albino's dodgy spacing of ){ and if( else{
perl -i.bak -pne 's[\)\{][) {]xmsg; s[if\(][if (]xmsg; s[else\{][else {]xmsg; ' $*
