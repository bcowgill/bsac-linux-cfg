#!/bin/bash
# split a file on commas
# WINDEV tool useful on windows development machine
perl -pne 's{,}{,\n   }xmsg' $*
