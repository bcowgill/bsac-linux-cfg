#!/bin/bash
# Show what must be done
# Looks for MUSTDO markers and lists file/line number nicely
# See also git-mustdo.sh grep-lint.sh
# WINDEV tool useful on windows development machine

LABEL=${1:-MUSTDO}
DIR=${2:-.}
egrep -rn $LABEL $DIR | perl -pne 's{\A \.+/}{}xms; s{:(\d+):\s*}{ : $1\t}xms'
