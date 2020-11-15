#!/bin/bash
# take a list of javascript files and output some javascript to import each one.
# ls *.spec.js | RELATIVE=./ mk-js-imports.sh > combined.test.js
# WINDEV tool useful on windows development machine
perl -pne '$prefix = $ENV{RELATIVE}; $q = chr(39); chomp; $_ = qq{import $q$prefix$_$q;\n}'
