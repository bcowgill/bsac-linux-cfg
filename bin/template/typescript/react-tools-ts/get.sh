#!/bin/bash
F=/tmp/fmt/fmt-wrap
S=.
cp $F/tscompiler.ts $S/tscompiler.txt
cp $F/tslangorg.ts  $S/tslangorg.txt
cp $F/tsrunner.ts   $S/
cp $F/detect.ts     $S/
cp \
$F/diffState.ts \
$F/mockBroadcastChannel.ts \
$F/setupTests.ts \
$F/useFlag.test.ts \
$F/useFlag.ts \
$F/useWindowSize.ts \
$S/


#$F/preTestTools.ts \
#$F/testingTools.test.ts \
#$F/testingTools.ts \
