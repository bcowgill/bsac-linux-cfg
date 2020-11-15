#!/bin/bash
# Show what must be done to some git files
# Looks for MUSTDO markers and lists file/line number nicely
# See also grep-lint.sh mustdo.sh
# WINDEV tool useful on windows development machine

LABEL=${1:-MUSTDO}
git grep -En $LABEL | perl -pne 's{\A \.+/}{}xms; s{:(\d+):\s*}{ : $1\t}xms'
