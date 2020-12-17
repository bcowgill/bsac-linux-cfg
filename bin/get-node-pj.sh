#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grab the project files needed to set up a new JS/node project with tests, jsdoc etc

FROM=/cygdrive/d/d/s/github
if [ ! -d $FROM ] ; then
	FROM=~/workspace/play
fi
FROM=$FROM/perljs

TO=${1:-newpj}
echo TO=$TO

[ -d $TO ]         || mkdir -p $TO
[ -d $TO/doc ]     || mkdir -p $TO/doc
[ -d $TO/lib ]     || mkdir -p $TO/lib
[ -d $TO/test ]    || mkdir -p $TO/test
[ -d $TO/scripts ] || mkdir -p $TO/scripts

cp $FROM/.gitignore \
	$FROM/.jshintignore \
	$FROM/.jshintrc-gruntfile \
	$FROM/.jshintrc-node \
	$FROM/.npmignore \
	$FROM/package.json \
	$FROM/Gruntfile.js \
	$FROM/jsdoc.conf.json \
	$TO

cp $FROM/scripts/cygwin.sh \
	$TO/scripts
