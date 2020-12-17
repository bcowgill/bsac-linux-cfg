#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# npm list all top level development packages
# See also nonpmproxy.sh, npm-ls-prod.sh, npm-fixup.sh, npm-ls.sh, npm-up-dev.sh, npm-up-prod.sh, npm-pkg-vers.js, packagever.sh
# WINDEV tool useful on windows development machine
npm list --dev --depth=0 | tail -n +2 | perl -pne 's{\A[^\(a-z]+}{}xmsg'
