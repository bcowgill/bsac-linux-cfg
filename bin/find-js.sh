#!/bin/bash
# find all javascript files excluding minimised and .git node_modules and bower_components
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.jsx?$' \
	| egrep -i '\.jsx$'

