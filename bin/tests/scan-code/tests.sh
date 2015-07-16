#!/bin/bash
[ ! -d out ] && mkdir out
../../scan-code.sh in | perl -pne 's{\.js:\d+:}{.js:NN:}xmsg' > out/scanme.out
diff out/scanme.out base/scanme.base

