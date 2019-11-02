#!/bin/bash
# find all perl files
find-code.sh \
	| egrep -i '\.p[lm]$'
