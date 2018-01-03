#!/bin/bash
# checkout two branches minus .git and node_modules dirs for direct file diffing.

REPO=../pas-card-controls-cwa
BRANCH=develop
BR_DIR=$BRANCH
OTHER=sprint16/carouselFix
OTHER_DIR=carouselFix

rm -rf $BR_DIR
rm -rf $OTHER_DIR

pushd $REPO
git checkout $BRANCH
tar cvzf getfordiff1.tgz --exclude node_modules --exclude .git .
git checkout $OTHER
tar cvzf getfordiff2.tgz --exclude node_modules --exclude .git .
popd

mv $REPO/getfordiff*.tgz .

mkdir $BR_DIR
pushd $BR_DIR
tar xvzf ../getfordiff1.tgz
popd

mkdir $OTHER_DIR
pushd $OTHER_DIR
tar xvzf ../getfordiff2.tgz
popd

rm */applications/*/bundle-report.html

for F in `find $BR_DIR -type f`; do
	O=`perl -e 'my ($file, $dir, $dir2) = @ARGV; $file =~ s{\A$dir}{$dir2}xms; print $file' $F $BR_DIR $OTHER_DIR`
	if [ -e "$O" ]; then
		if diff "$F" "$O" >> /dev/null; then
			rm "$F" "$O"
		fi
	fi
done
