#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all stylesheet files excluding minimised and .git node_modules and bower_components
# See also all-debug-css.sh, css-diagnose.sh, debug-css.sh, filter-css-colors.pl, find-css.sh, invert-css-color.pl
# WINDEV tool useful on windows development machine
find-code.sh \
	| egrep -vi '(\.|-)(min|pack)\.(c|le|sa|sc)ss$' \
	| egrep -i '\.(c|le|sa|sc)ss$'
