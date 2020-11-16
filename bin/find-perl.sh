#!/bin/bash
# find all perl files
# WINDEV tool useful on windows development machine
find-code.sh \
	| egrep -i '\.p[lm]$'
