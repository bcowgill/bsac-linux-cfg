#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all perl files
# WINDEV tool useful on windows development machine
find-code.sh \
	| egrep -i '\.p[lm]$'
