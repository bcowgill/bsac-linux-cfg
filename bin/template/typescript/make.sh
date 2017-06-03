#!/bin/bash
# transpile all the other examples to dist/
# then, if 'all' specified
# transpile example module formats to trans/ and modules/[type]

ALL=${1:-one}

function go
{
	transpile_all
	if [ $ALL == one ]; then
		exit 0
	fi
	./make-trans.sh
	pushd modules && (./make.sh; popd)
}

function transpile_all
{
	rm -rf dist/;
	json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig.json ;
	#json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig-debug.json ;
	rm *.json
	json5 -c tsconfig.json5
}

go

