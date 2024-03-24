#!/bin/bash
# direct AJV examples from the website docs:
#npx ts-node ajv-json.ts
#npx ts-node ajv-jtd.ts

function filter_output
{
	local SRC
	SRC="$1"
	# fix up line and column numbers for diffing...
	perl -i -pne 's{s:\d+:\d+}{s:LLL:CCC}xmsg' $SRC
}

function check_output
{
	local SRC
	SRC="$1"
	filter_output $SRC*.out

	[ -e $SRC.base ] || touch $SRC.base
	[ -e $SRC.err.base ] || touch $SRC.err.base
	diff $SRC.out $SRC.base || echo "NOT OK - Standard Output differs from base file: vdiff $SRC.out $SRC.base"
	diff $SRC.err.out $SRC.err.base || echo "NOT OK - Standard Error differs from base file: vdiff $SRC.err.out $SRC.err.base"
}

if node --version | grep `cat .nvmrc`; then \
	SRC=index.ts
	#npx ts-node $SRC && \
	npx ts-node $SRC > $SRC.out 2> $SRC.err.out
	check_output $SRC

	SRC=index.js
	node $SRC > $SRC.out 2> $SRC.err.out
	check_output $SRC

	exit 55
	SRC=index.ajv.ts
	npx ts-node $SRC \
		&& npx ts-node $SRC > $SRC.out 2> $SRC.err.out
	check_output $SRC

else
	echo "You need to run: nvm use"
	echo "to set the correct version of node [`cat .nvmrc`] for this project."
fi
