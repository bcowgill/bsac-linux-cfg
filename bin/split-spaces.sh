#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# split a file on spaces
# See also split-brace.sh, split-comma.sh, splitdiff, split-jest-snapshot.pl, split-list.pl, split-long.sh, split-semicolon.sh
# WINDEV tool useful on windows development machine
perl -pne 's{([^\A])\s+}{$1\n   }xmsg; s{\n\s+\z}{\n}xms;' $*
