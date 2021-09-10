#!/bin/bash

PROVE=$1
for suite in plus minus common insert translate;
do
	$PROVE ./test-json-$suite.sh
done
