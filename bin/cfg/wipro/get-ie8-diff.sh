#!/bin/bash
# checkout two branches minus .git and node_modules dirs for direct file diffing.

REPO=../pas-card-controls-cwa
REPO_IE8=../pas-card-controls-cwa-mca-ie8

BRANCH=master
BR_DIR=cwa-$BRANCH

OTHER=master
OTHER_DIR=ie8-$OTHER

EXCLUDE="--exclude node_modules --exclude .git --exclude applications/nga --exclude applications/mca/dist"

rm -rf $BR_DIR
rm -rf $OTHER_DIR

pushd $REPO
git fetch --all
git checkout $BRANCH
git pull
tar cvzf getfordiff1.tgz $EXCLUDE .

cd $REPO_IE8
git fetch --all
git checkout $OTHER
git pull
tar cvzf getfordiff2.tgz $EXCLUDE .
popd

mv $REPO/getfordiff1.tgz .
mv $REPO_IE8/getfordiff2.tgz .

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

./leave-diffs-only.sh "$BR_DIR" "$OTHER_DIR"
