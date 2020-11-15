#!/bin/bash
# split a file on semi-colons
# WINDEV tool useful on windows development machine
perl -pne 's{;}{;\n   }xmsg' $*
