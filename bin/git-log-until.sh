#!/bin/bash
if [ -z "$1" ]; then
	echo "
usage: $(basename $0) commit-hash

This will perform a git log showing everything up to the commit-hash specified.
"
	exit 1
fi
git log | COMMIT="$1" perl -ne 'print unless $stop; $stop = $stop || m{$ENV{COMMIT}}xms'
