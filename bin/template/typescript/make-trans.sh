#!/bin/bash
# transpile example module formats to trans/

function go
{
	make_modules
}

function setup
{
	# setup for building various modules from source
	tar czf typescript.tgz *.ts modules/
	rm -rf *.ts modules/
	json5 -c tsconfig*.json5
	[ -d trans ] || mkdir trans
}

function cleanup
{
	# restore source code after
	tar xzf typescript.tgz
	rm typescript.tgz
	rm -rf src/
	rm *.json
	json5 -c tsconfig.json5
}

function transpile_module
{
	local modes source out
	modes=$1
	source=$2
	out=${3:-$source}

	echo src/$source.ts to dist/$out.js as $modes

	rm -rf src && mkdir src/
	tar xvzf typescript.tgz --directory src/ $source.ts

	rm -rf dist/
	tsc --newline LF --project tsconfig-$modes.json

	(\
		echo "/* $source.d.ts - $modes";\
		cat dist/$out.d.ts;\
		echo "*/";\
		echo " ";\
		echo "// $source.js - $modes";\
		cat dist/$out.js\
	) > trans/$source.$modes

	echo created trans/$source.$modes
}

function make_modules
{
	setup
	for es in es5 es6
	do
		for mod in es2015 commonjs system amd umd
		do
			transpile_module $mod.$es weird
			transpile_module $mod.$es weird-namespace
		done
	done
	cleanup
}

go
