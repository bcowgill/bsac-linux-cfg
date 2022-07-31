#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all web development files excluding minimised and .git node_modules and bower_components
# WINDEV tool useful on windows development machine
egrep -vi '(\.|-)(min|pack)\.((c|le|sa|sc)ss|html?|ts|jsx?|json5?)\b' \
	| egrep -i '\.((c|le|sa|sc)ss|html?|ts|jsx?|json5?)\b' # .css .less .sass .scss .htm .html .ts .js .jsx .json .json5
