#!/bin/bash
# find all json files excluding .git node_modules and bower_components
find-code.sh \
| egrep -vi '\.(bak|orig)$' \
| egrep '\.jshintrc|\.json5?$|Gruntfile'

