#!/bin/bash
# find all web development files excluding minimised and .git node_modules and bower_components
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.((c|le|sa|sc)ss|html?|jsx?|json5?)$' \
	| egrep -i '\.((c|le|sa|sc)ss|html?|jsx?|json5?)$'
