#!/bin/bash
# filter out the names of files which are built or part of bower/node component syste
# usage egrep -rl something | filter-built-files.sh
egrep -v '/(node_modules|bower_components|dist|\.tmp|app/assets)/' \
	| egrep -v 'cirrus/public/new-ui/' | egrep -v '\.log(:|$)'
