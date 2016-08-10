#!/bin/bash
# run a command in a directory
DIR=$1
shift
pushd $DIR && ($*; popd)

