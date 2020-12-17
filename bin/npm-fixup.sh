#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# remove node_modules and reinstall
# See also nonpmproxy.sh, npm-ls-prod.sh, npm-ls-dev.sh, npm-ls.sh, npm-up-dev.sh, npm-up-prod.sh, npm-pkg-vers.js, packagever.sh
# WINDEV tool useful on windows development machine
rm -rf node_modules
npm install
