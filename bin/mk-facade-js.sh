#!/bin/bash
# make a javascript facade file to load another module as index.js
# WINDEV tool useful on windows development machine

GIT=1
FACADE_TEMPLATE=

function usage
{
	local message
	message="$1"
	echo "$message"
	echo "
usage: $(basename $0) path/to/module/index.js [extension] [facade-test-template]

This will create a javascript Facade file for a given module directory.

extension will be jsx by default.
facade-test-template specifies a template test plan to copy.

It [git] moves the index.js to module.extension.
It moves the index.spec.js to module.spec.extension if necessary
It creates a new index.js which exports everything from module.extension.
It creates an index.spec.js test plan for the facade file using a template file.
"
	exit 0
}

# path/to/module/index.js -> module
function module_name
{
	local file
	file=`dirname "$1"`
	file=`basename "$file"`
	echo $file
}

function move
{
	local from to
	from="$1"
	to="$2"
	echo moving "$from" "$to"
	if [ $GIT == 1 ]; then
		git mv "$from" "$to"
		git commit --no-verify -m "mk-facade-js moved $from to $to so that a facade loader can be created"
	else
		mv "$from" "$to"
	fi
}

function copy
{
	local from to
	from="$1"
	to="$2"
	echo copying "$from" "$to"
	if [ $GIT == 1 ]; then
		cp "$from" "$to"
		git add "$to"
		git commit --no-verify -m "mk-facade-js copied $from to $to so that a facade loader can be created"
	else
		cp "$from" "$to"
	fi
}

function make_facade
{
	local from module
	from="$1"
	module="$2"

	echo creating facade file "$from"
	echo "export * from './$module';" > "$from"
	echo "export { default } from './$module';" >> "$from";
	if [ $GIT == 1 ]; then
		git add "$from"
		git commit --no-verify -m "mk-facade-js created facade loader $from to load $module"
	fi
}

#============================================================================
FROM="$1"
EXT="${2-jsx}"
FACADE_TEMPLATE="$3"

if [ -z "$FROM" ]; then
	usage "You must provide a path to an existing index.js file."
fi

BASENAME=`basename "$FROM" .jsx`
BASENAME=`basename $BASENAME .js`
DIR=`dirname "$FROM"`
MODULE=`module_name "$FROM"`

##echo DIR=$DIR
##echo MODULE=$MODULE
##echo BASENAME=$BASENAME

if [ "$MODULE" == "/" ]; then
	usage "You cannot specify / as path we need to know the containing directory name."
fi

if [ "$MODULE" == "." ]; then
	usage "You cannot specify ./ as path we need to know the containing directory name."
fi

if [ "$MODULE" == ".." ]; then
	usage "You cannot specify ../ as path we need to know the containing directory name."
fi

if [ "$BASENAME" != "index" ]; then
	usage "You must specify an index.js file."
fi

TO="$DIR/$MODULE.$EXT"
##echo TO="$TO"

if [ -f "$TO" ]; then
	echo "Error $TO already exists, will not clobber it."
	exit 1
fi

TEST_PLAN="$DIR/index.spec.js"
TEST_PLAN_TO=

if [ -f "$TEST_PLAN" ]; then
	TEST_PLAN_TO="$DIR/$MODULE.spec.$EXT"
	if [ -f "$TEST_PLAN_TO" ]; then
		echo "Error $TEST_PLAN_TO already exists, will not clobber it."
		exit 1
	fi
fi

if [ ! -z "$FACADE_TEMPLATE" ]; then
	if [ ! -f "$FACADE_TEMPLATE" ]; then
		echo "Error $FACADE_TEMPLATE does not exist, cannot use it to create the test plan for the new facade."
		exit 1
	fi
fi

##echo TEST_PLAN=$TEST_PLAN
##echo TEST_PLAN_TO=$TEST_PLAN_TO
##echo FACADE_TEMPLATE=$FACADE_TEMPLATE

move "$FROM" "$TO"
#make_facade "$FROM" "$MODULE.$EXT"
make_facade "$FROM" "$MODULE"
if [ ! -z "$TEST_PLAN_TO" ]; then
	move "$TEST_PLAN" "$TEST_PLAN_TO"
fi

if [ ! -z "$FACADE_TEMPLATE" ]; then
	copy "$FACADE_TEMPLATE" "$TEST_PLAN"
fi
