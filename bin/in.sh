#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# run a command in a directory
# WINDEV tool useful on windows development machine
DIR=$1
shift
pushd $DIR && ($*; popd)

