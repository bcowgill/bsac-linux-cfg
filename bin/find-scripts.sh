#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/tcl
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(awk|bat|(ba?|fi|t?c|[vz])?sh|p[lmy]|php|rb|sed|tcl)$' # .pl .pm .py .sh .bsh .bash .fish .tsh .tcsh .vsh .zsh

