#!/bin/bash
# split a file on spaces
perl -pne 's{([^\A])\s+}{$1\n   }xmsg; s{\n\s+\z}{\n}xms;' $*
