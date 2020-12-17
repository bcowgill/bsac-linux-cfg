#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# filter out file names which are source code / configuration files
# See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh
# WINDEV tool useful on windows development machine
egrep -vi '(robots\.txt|pre-commit|(Make|Gem|Rake)file)$' \
	| egrep -vi '\.(p[lm]|sh|bash|bat|cmd|js|json|css|less|scss|html?|c?shtml?|x[ms]l|jade|hbs|asm?|c|cs|cpp|java|jsp|py|python|e?rb|rspec|rake|ru|coffee|eco|sql|md|conf|config|properties|yml|(git|npm|jshint)ignore|git(attributes|modules)|htaccess|editorconfig|(bower|csslint|jshint|vim)rc|jshintrc-\w+)$' | egrep -vi '\.(txt|log1?|jinja|jinger|tolerance|eml|iml|lst|sample|out|old|new|au3)$'
