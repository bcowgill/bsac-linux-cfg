#!/bin/bash
# checkout two branches minus .git and node_modules dirs for direct file diffing.

REPO=../pas-card-controls-cwa

#BRANCH=master
#BR_DIR=$BRANCH
BRANCH=sprint0/belogger
BR_DIR=belogger

OTHER=master
OTHER_DIR=$OTHER

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

./leave-only-diffs.sh "$BR_DIR" "$OTHER_DIR"
