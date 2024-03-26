#!/bin/bash

NEXT=filter-css

./tests.sh
if [ ! -z "$1" ]; then
	if [ -x "../$1" ]; then
		echo "Running ../$1 from `pwd`"
		../$1
	else
		echo "ERROR: command '../$1' is not executable as seen from `pwd`, terminating the chain."
		exit 44
	fi
fi
cd ../$NEXT
./test-chain.sh
