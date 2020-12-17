#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# fix up Albino's (https://www.linkedin.com/in/albinotonnina/) dodgy spacing of ){ and if( else{
# WINDEV tool useful on windows development machine
perl -i.bak -pne 's[\)\{][) {]xmsg;
    s[(function|if)\(][$1 (]xmsg;
    s[(else)\{][$1 {]xmsg;
    ' $*
