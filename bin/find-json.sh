#!/bin/bash
# find all json files excluding .git node_modules and bower_components
find-code.sh \
| egrep -v '\.(bak|orig)$' \
| egrep '\.jshintrc|\.json$|Gruntfile'

