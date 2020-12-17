#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
find /Applications -name *.app | perl -pne 'chomp; s{\A (.+/) (.+\.app) $}{$2 $1}xmsg; $_ .= "\n"'
