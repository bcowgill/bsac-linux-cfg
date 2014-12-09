#!/bin/bash

# specify 'prove' on command line to use prove command to run tests.
PROVE=${1:-}

source ./shell-test.sh

testSuite ls-tt-tags "list template toolkit tags in templates" $PROVE
testSuite render-tt "render a perl Template::Toolkit page with specific variables set" $PROVE
testSuite filter-css-colors "filter and replace CSS colors in files" $PROVE
testSuite perltidy-me "evaluate perltidy formatting options" $PROVE
testSuite pretty-elements "format HTML elements nicely" $PROVE
testSuite spaces "show spaces nulls and end of lines" $PROVE
testSuite ls-tabs "report on tab indentation in file" $PROVE

PLAN 2
OK "all test suites completed"
