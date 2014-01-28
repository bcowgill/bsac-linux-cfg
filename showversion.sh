#!/bin/bash
perl -ne 'if (s{\A .* (\$Rev[^\$]*\$) .* \z}{$1\n}xms) { print }' $*

