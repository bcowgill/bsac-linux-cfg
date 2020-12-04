#!/bin/bash
# cover-one.sh testplanfilenameorportion "test description..."
TESTLOG=_tests.log
TEST="$1"
GREP="$2"

if [ -z "$TEST" ]; then
	echo "
$(basename $0) filename ["description"]

Run only jest tests which match the filename given and watch for changes updating coverage.

And which match the optional test description.
"
	exit 1
fi

if [ ! -z "$GREP" ]; then
	npm test -- --coverage -f "$TEST" -t "$GREP" 2>&1 | pee.pl $TESTLOG
else
	npm test -- --coverage -f "$TEST" 2>&1 | pee.pl $TESTLOG
fi
