#!/bin/bash
# Shows CVS/SVN Revision for a file.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
perl -ne 'if (s{\A .* (\$Rev[^\$]*\$) .* \z}{$1\n}xms) { print }' $*

