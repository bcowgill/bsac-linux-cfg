#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# split a file on semi-colons
# See also split-brace.sh, split-comma.sh, splitdiff, split-jest-snapshot.pl, split-list.pl, split-long.sh, split-spaces.sh
# WINDEV tool useful on windows development machine
perl -pne 's{;}{;\n   }xmsg' $*
