#!/bin/bash
# find all javascript files excluding minimised and .git node_modules and bower_components
# WINDEV tool useful on windows development machine
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.jsx?$' \
	| egrep -i '\.jsx$'

