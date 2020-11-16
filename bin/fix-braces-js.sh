#!/bin/bash
# fix up Albino's dodgy spacing of ){ and if( else{
# WINDEV tool useful on windows development machine
perl -i.bak -pne 's[\)\{][) {]xmsg;
    s[(function|if)\(][$1 (]xmsg;
    s[(else)\{][$1 {]xmsg;
    ' $*
