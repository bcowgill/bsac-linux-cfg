#!/bin/bash
[ -d src ] || mkdir src
cp tscompiler.txt src/tscompiler.ts
cp tslangorg.txt src/tslangorg.ts
cp tsrunner.ts src/
cp detect.ts src/
cp \
diffState.ts \
mockBroadcastChannel.ts \
setupTests.ts \
useFlag.test.ts \
useFlag.ts \
useWindowSize.ts \
src/

#testingTools.test.ts \
#preTestTools.ts \
#testingTools.ts \

#deno fmt --check
#deno lint -c deno.jsonc --fix
deno lint -c deno.jsonc
#deno fmt -c deno.jsonc
