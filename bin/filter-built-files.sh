#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# filter out the names of files which are built or part of bower/node component syste
# usage egrep -rl something | filter-built-files.sh
# See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh
# WINDEV tool useful on windows development machine
# CUSTOM settings you may have to change on a new computer
egrep -v '/(\.tmp|\.git|\.idea|dist|coverage|node_modules|bower_components|deno-packages|app/assets)/' \
	| egrep -v 'cirrus/public/'
