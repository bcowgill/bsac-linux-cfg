#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# npm update all top level production packages to latest version
# See also npm-fixup.sh, npm-ls-prod.sh, npm-ls-dev.sh, npm-ls.sh, npm-up-dev.sh, npm-pkg-vers.js, nonpmproxy.sh, packagever.sh
# WINDEV tool useful on windows development machine
npm install --save `npm-ls-prod.sh | perl -pne 's{(\@).+\n}{$1latest\n}xmsg;'` $*
