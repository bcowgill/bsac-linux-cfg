#!/bin/bash

PROVE=$1
for suite in plus minus common;
do
	./test-json-$suite.sh $PROVE
done
