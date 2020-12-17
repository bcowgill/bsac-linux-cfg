#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# npm update all top level development packages to latest version
# See also npm-fixup.sh, npm-ls-prod.sh, npm-ls-dev.sh, npm-ls.sh, npm-up-prod.sh, npm-pkg-vers.js, nonpmproxy.sh, packagever.sh
# WINDEV tool useful on windows development machine
npm install --save-dev `npm-ls-dev.sh | perl -pne 's{(\@).+\n}{$1latest\n}xmsg;'` $*
