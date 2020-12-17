#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
ctags --verbose --totals=yes -e -R --extra=+fq --exclude=.git $* -f TAGS
