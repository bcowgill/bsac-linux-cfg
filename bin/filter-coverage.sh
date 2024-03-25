#!/bin/bash
# Filter the jest test plan output to hide coverate that is all zero or all 100%
# coverage not met:   will be hidden
# | 0 | 0 | 0 | 0 |
# | 100 | 100 | 100 | 100 |
# npm run test --color 2>&1 | filter-coverage.sh
grep -vE 'coverage.+not met:|(\|\s*(.\[[0-9;]+m)?\s*0\s*(.\[[0-9;]+m)?\s*){4}|(\|\s*(.\[[0-9;]+m)?\s*100\s*(.\[[0-9;]+m)?\s*){4}' $*
#ERR=$?
#if [ $ERR != 0 ]; then
#	usage $ERR
#fi
