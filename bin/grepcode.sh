#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grep through code for some stuff
# See also find-code.sh
egrep -rli "$1" . | egrep -v '/\.svn/|\.git/|/docs/|/test/(base|out)/\.(pdf|class)$'
