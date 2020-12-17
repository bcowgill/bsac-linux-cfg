#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# scan the javascript tests for disabled tests
# See also git-fix-tests.sh, git-grep-skipped.sh, mk-facade-js.sh, scan-specs.sh, skip-tests.sh
# WINDEV tool useful on windows development machine
# CUSTOM settings may need to change these on a new computer
#TESTS="'*.test.js'"
TESTS="'*.spec.js'"

MAX_SKIP=10
color=--color


# any ocurrence of .only() is a failure
ERROR=0

# anything inheriting from LoggedComponent prevents build
if git grep LoggedComponent | egrep 'import .+ from' | grep -v LoggedComponent.story.js | grep $color LoggedComponent; then
	echo ERROR: inherit from BaseComponent for production builds.
	ERROR=3
fi

git grep -E '^\s*(describe|it)\.skip' -- $TESTS | egrep $color 'skip|only'

# any ocurrence of top level describe.skip() is a failure
if git grep -E '^describe\.skip' -- $TESTS | egrep $color 'skip|only' > /dev/null ; then
	echo ERROR: entire test plan skipped
	git grep -E '^describe\.skip' -- $TESTS | egrep $color 'skip|only'
	ERROR=2
fi

# any ocurrence of .only() is a failure
if git grep -E '^\s*(describe|it)\.only' -- $TESTS | egrep $color 'skip|only' > /dev/null ; then
	echo ERROR: tests being skipped because of only
	git grep -E '^\s*(describe|it)\.only' -- $TESTS | egrep $color 'skip|only'
	ERROR=1
fi

# too many skipped tests is a failure
SKIPS=`git grep -E '^\s*(describe|it)\.skip' -- $TESTS | wc -l`

if [ $SKIPS -gt $MAX_SKIP ]; then
	ERROR=$SKIPS
	echo ERROR: $SKIPS skipped tests or test suites found
else
	echo $SKIPS skips found, no big deal
fi

exit $ERROR
