#!/bin/bash
[ -d src ] || mkdir src
cp tscompiler.txt src/tscompiler.ts
cp tslangorg.txt src/tslangorg.ts
cp tsrunner.ts src/
cp detect.ts src/
deno fmt --check
#deno fmt