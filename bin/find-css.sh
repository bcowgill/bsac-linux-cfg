#!/bin/bash
# find all stylesheet files excluding minimised and .git node_modules and bower_components
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.(c|le|sa)ss$' \
	| egrep -i '\.(c|le|sa)ss$'
