#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# split a file on braces
# See also split-comma.sh, splitdiff, split-jest-snapshot.pl, split-list.pl, split-long.sh, split-semicolon.sh, split-spaces.sh
# WINDEV tool useful on windows development machine
perl -pne 's[\}][\n}\n]xmsg; s[\{][{\n   ]xmsg; ' $*
