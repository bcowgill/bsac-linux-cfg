#!/bin/bash
# checkout two branches minus .git and node_modules dirs for direct file diffing.

REPO=../pas-card-controls-cwa

BRANCH=sprint16/cf
BR_DIR=cf
#BRANCH=develop
#BR_DIR=$BRANCH
#BRANCH=sprint0/belogger
#BR_DIR=belogger

#OTHER=sprint16/carouselFix2
#OTHER_DIR=carouselFix2
#OTHER=sprint0/trunk
#OTHER_DIR=trunk
#OTHER=master
#OTHER_DIR=$OTHER
OTHER=sprint16/cf-saved
OTHER_DIR=cf-saved

EXCLUDE="--exclude node_modules --exclude .git"

rm -rf $BR_DIR
rm -rf $OTHER_DIR

pushd $REPO
git fetch --all
git checkout $BRANCH
git pull
tar cvzf getfordiff1.tgz $EXCLUDE .
git checkout $OTHER
git pull
tar cvzf getfordiff2.tgz $EXCLUDE .
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

# Custom removal of files we don't care about
rm */applications/*/bundle-report.html

# TODO make a function
# Remove identical files and touch a counterpart for new files.
for F in `find $BR_DIR -type f`; do
	O=`perl -e 'my ($file, $dir, $dir2) = @ARGV; $file =~ s{\A$dir}{$dir2}xms; print $file' $F $BR_DIR $OTHER_DIR`
	if [ -e "$O" ]; then
		if diff "$F" "$O" >> /dev/null; then
			rm "$F" "$O"
		fi
	else
		mkdir -p "$O"
		rmdir "$O"
		touch "$O"
	fi
done

# Remove identical files and touch a counterpart for deleted files.
for F in `find $OTHER_DIR -type f`; do
	O=`perl -e 'my ($file, $dir, $dir2) = @ARGV; $file =~ s{\A$dir}{$dir2}xms; print $file' $F $OTHER_DIR $BR_DIR`
	if [ -e "$O" ]; then
		if diff "$F" "$O" >> /dev/null; then
			rm "$F" "$O"
		fi
	else
		mkdir -p "$O"
		rmdir "$O"
		touch "$O"
	fi
done

# Remove all empty directories to simplify things.
find $BR_DIR -type d -depth -exec rmdir {} \;
find $OTHER_DIR -type d -depth -exec rmdir {} \;

echo vdiff $BR_DIR $OTHER_DIR
