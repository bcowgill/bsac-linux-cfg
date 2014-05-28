#!/bin/bash

source ./shell-test.sh

testSuite ls-tt-tags "list template toolkit tags in templates"
testSuite filter-css-colors "filter and replace CSS colors in files"

echo OK all test suites completed
