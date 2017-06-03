#!/bin/bash
# make all the typescript into different module formats

function ignore
{
	local mode module file
	mode=$1
	module=$2
	file=$3

	if [ $module == $mode ]; then
		echo $mode: suppress incompatible example $file
		mv $file $file.ignore
	fi
}

function restore
{
	local mode module file
	mode=$1
	module=$2
	file=$3

	if [ $module == $mode ]; then
		mv $file.ignore $file
	fi
}

TYPES="commonjs amd umd es2015 system"
for T in $TYPES
do
	echo making $T
	[ -d $T ] || mkdir $T
	rm *.js 2> /dev/null
	ignore $T system ModuleExportEq.ts
	ignore $T system use-module-export-eq.ts
	ignore $T es2015 ModuleExportEq.ts
	ignore $T es2015 use-module-export-eq.ts

	tsc --project tsconfig-$T.json 2>&1 | tee $T/build.log
	mv *.js $T
	restore $T system ModuleExportEq.ts
	restore $T system use-module-export-eq.ts
	restore $T es2015 ModuleExportEq.ts
	restore $T es2015 use-module-export-eq.ts
done
