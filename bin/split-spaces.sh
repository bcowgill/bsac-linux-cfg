#!/bin/bash
# split a file on spaces
# WINDEV tool useful on windows development machine
perl -pne 's{([^\A])\s+}{$1\n   }xmsg; s{\n\s+\z}{\n}xms;' $*
