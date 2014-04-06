#!/bin/bash
# split a file on commas
perl -pne 's{,}{,\n   }xmsg' $*
