#!/bin/bash
# run a command in a directory
# WINDEV tool useful on windows development machine
DIR=$1
shift
pushd $DIR && ($*; popd)

