#!/bin/bash
# filter out the names of files which are built or part of bower/node component syste
# usage egrep -rl something | filter-built-files.sh
# WINDEV tool useful on windows development machine
# CUSTOM settings you may have to change on a new computer
egrep -v '/(node_modules|bower_components|dist|\.tmp|app/assets)/' \
	| egrep -v 'cirrus/public/'
