#!/bin/bash
# scan the javascript tests for disabled tests

MAX_SKIP=10

# any ocurrence of .only() is a failure
ERROR=0

git grep -E '^\s*(describe|it)\.skip' -- '*.spec.js' | egrep --color 'skip|only'

# any ocurrence of top level describe.skip() is a failure
if git grep -E '^describe\.skip' -- '*.spec.js' | egrep --color 'skip|only' > /dev/null ; then
	echo ERROR: entire test plan skipped
	git grep -E '^describe\.skip' -- '*.spec.js' | egrep --color 'skip|only'
	ERROR=2
fi

if git grep -E '^\s*(describe|it)\.only' -- '*.spec.js' | egrep --color 'skip|only' > /dev/null ; then
	echo ERROR: tests being skipped because of only
	git grep -E '^\s*(describe|it)\.only' -- '*.spec.js' | egrep --color 'skip|only'
	ERROR=1
fi

# too many skipped tests is a failure
SKIPS=`git grep -E '^\s*(describe|it)\.skip' -- '*.spec.js' | wc -l`

if [ $SKIPS -gt $MAX_SKIP ]; then
	ERROR=$SKIPS
	echo ERROR: $SKIPS skipped tests or test suites found
else
	echo $SKIPS skips found
fi

exit $ERROR
