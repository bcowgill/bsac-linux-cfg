#!/bin/bash
# fix up libraries pulled in by benchmark page after parcel does its thing.
OUT=dist/
rm $OUT/benchmark.*.map $OUT/platform.*.map $OUT/lodash.*.map
cp node_modules/benchmark/benchmark.js $OUT/benchmark.*.js
cp node_modules/lodash/lodash.js $OUT/lodash.*.js
cp node_modules/platform/platform.js $OUT/platform.*.js
LIB=`basename $(ls $OUT/bench-runner.*.js)` perl -i -pne 'my $lib = $ENV{LIB}; s{bench-runner\.[^.]+\.js}{$lib}xmsg' $OUT/benchmark.html
