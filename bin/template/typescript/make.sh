#!/bin/bash
# if 'all' specified
# transpile example module formats to trans/ and modules/[type]

# then transpile all the other examples to dist/

ALL=${1:-one}

function go
{
	if [ $ALL != one ]; then
		./make-trans.sh
		pushd modules && (./make.sh; popd)
	fi
	transpile_all
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

