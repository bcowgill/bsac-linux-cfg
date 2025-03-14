#!/bin/bash
[ -d src ] || mkdir src
cp tscompiler.txt src/tscompiler.ts
cp tslangorg.txt src/tslangorg.ts
cp tsrunner.ts src/
cp detect.ts src/
cp \
diffState.ts \
mockBroadcastChannel.ts \
preTestTools.ts \
setupTests.ts \
testingTools.test.ts \
testingTools.ts \
useFlag.test.ts \
useFlag.ts \
useWindowSize.ts \
src/

deno fmt --check
deno lint -c deno.jsonc --fix
#deno fmt -c deno.jsonc
