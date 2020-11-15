#!/bin/bash
# show the version from package.json (or bower.json)
# WINDEV tool useful on windows development machine

FILE=package.json
if [ ! -f $FILE ]; then
    FILE=bower.json
fi
perl -ne 'sub END { exit !$version }; if (m{("version" \s* : \s* ")([\.0-9]+)(",)}xms) { $version = $2; print $2; exit 0 }' $FILE
