#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show the version from package.json (or bower.json)
# See also npm-fixup.sh, npm-ls-prod.sh, npm-ls-dev.sh, npm-up-dev.sh, npm-up-prod.sh, npm-pkg-vers.js, nonpmproxy.sh, packagever.sh
# WINDEV tool useful on windows development machine

FILE=package.json
if [ ! -f $FILE ]; then
    FILE=bower.json
fi
perl -ne 'sub END { exit !$version }; if (m{("version" \s* : \s* ")([\.0-9]+)(",)}xms) { $version = $2; print $2; exit 0 }' $FILE
