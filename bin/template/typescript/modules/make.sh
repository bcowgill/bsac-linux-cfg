#!/bin/bash
# make all the typescript into different module formats

TYPES="commonjs amd umd es2015 system"
for T in $TYPES
do
	echo making $T
	[ -d $T ] || mkdir $T
	rm *.js 2> /dev/null
	if [ $T == es2015 ]; then
		mv ModuleExportEq.ts ignore1
		mv use-module-export-eq.ts ignore2
	fi
	tsc --project tsconfig-$T.json 2>&1 | tee $T/build.log
	mv *.js $T
	if [ $T == es2015 ]; then
		mv ignore1 ModuleExportEq.ts
		mv ignore2 use-module-export-eq.ts
	fi
done
