#!/bin/bash
# Filter the jest/vitest test plan output to hide coverage that is all zero or all 100%
# coverage... not met:   will be hidden
# Coverage...does not meet  (vitest) will be hidden
# | 0 | 0 | 0 | 0 |
# | 100 | 100 | 100 | 100 |
# npm run test -- --color 2>&1 | filter-coverage.sh
# npm run test -- --watchAll=true --runTestsByPath $PLAN --color 2>&1 | filter-coverage.sh
# npm run test -- --coverage --watch $PLAN --color2>&1 | filter-coverage.sh
grep -vE 'Coverage.+does not meet|coverage.+not met:|(\|\s*(.\[[0-9;]+m)?\s*0\s*(.\[[0-9;]+m)?\s*){4}|(\|\s*(.\[[0-9;]+m)?\s*100\s*(.\[[0-9;]+m)?\s*){4}' $*
#ERR=$?
#if [ $ERR != 0 ]; then
#	usage $ERR
#fi
