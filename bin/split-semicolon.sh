#!/bin/bash
# split a file on semi-colons
perl -pne 's{;}{;\n   }xmsg' $*
