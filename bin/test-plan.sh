#!/bin/bash
# run a single test plan with coverage given by $1 or PLAN= value
# you can use -u as $2 to update snapshots
# filters the output to hide any files which have 4x 0% or 4x 100% coverage
# See also test-one.sh

if [ -z "$PLAN" ]; then
	PLAN=${1:-src/App.tsx}
fi
echo PLAN=$PLAN
ARGS="--coverage --watchAll --reporters=jest-junit $PLAN --color"
ARGS="--coverage $PLAN"
ARGS="--coverage --color $PLAN"
npm run test -- $ARGS $2 2>&1 \
	| grep --line-buffered -vE 'Coverage.+does not meet|coverage.+not met:|(\|\s*(.\[[0-9;]+m)?\s*0\s*(.\[[0-9;]+m)?\s*){4}|(\|\s*(.\[[0-9;]+m)?\s*100\s*(.\[[0-9;]+m)?\s*){4}' \
	| perl -ne 'print; s{\x1b\[\d+m}{}xmsg; print STDERR' 2> tests.log

