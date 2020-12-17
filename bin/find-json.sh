#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all json files excluding .git node_modules and bower_components
# WINDEV tool useful on windows development machine
find-code.sh \
| egrep -vi '\.(bak|orig)$' \
| egrep '\.jshintrc|\.json5?$|Gruntfile'

