#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# split a file on commas
# See also split-brace.sh, splitdiff.sh, split-jest-snapshot.pl, split-list.pl, split-long.sh, split-semicolon.sh, split-spaces.sh
# WINDEV tool useful on windows development machine
perl -pne 's{,}{,\n   }xmsg' $*
