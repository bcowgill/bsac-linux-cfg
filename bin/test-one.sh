#!/bin/bash
# test-one.sh testplanfilenameorportion ["test description..."]
TESTLOG=_tests.log
TEST="$1"
GREP="$2"
shift
shift

#RUN="TEST_DEBUG=1 npm test"
#RUN="npm test"
RUN="yarn test"
#PEE=pee.pl
PEE=tee
OPTS="--watchAll=false --collectCoverage=false --color $*"

#TEST_DEBUG=1 jest --config specs/jest.config.json --notify --onlyChanged --detectLeaks --detectOpenHandles --onlyFailures --forceExit --verbose --debug --testRegex $1

if [ -z "$TEST" ]; then
	echo "
$(basename $0) filename ["description"] [opts...]

Run only jest tests which match the filename given.

And which match the optional test description.

With additional options provided: $OPTS
"
	exit 1
fi

TEST=`echo $TEST | perl -pne 's{\.snap}{}xms; s{/__snapshots__}{}xms; s{\.js}{.test.js}xms unless m{\.test\.js}xms'`

echo TEST=$TEST

if [ ! -z "$GREP" ]; then
	$RUN $OPTS "$TEST" --testNamePattern "$GREP" 2>&1 | $PEE $TESTLOG
else
	$RUN $OPTS "$TEST" 2>&1 | $PEE $TESTLOG
fi
