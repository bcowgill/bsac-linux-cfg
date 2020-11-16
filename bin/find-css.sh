#!/bin/bash
# find all stylesheet files excluding minimised and .git node_modules and bower_components
# WINDEV tool useful on windows development machine
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.(c|le|sa|sc)ss$' \
	| egrep -i '\.(c|le|sa|sc)ss$'
