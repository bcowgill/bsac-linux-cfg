#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# npm list in a parseable/diffable format
# WINDEV tool useful on windows development machine
# See also npm-fixup.sh, npm-ls-prod.sh, npm-ls-dev.sh, npm-up-dev.sh, npm-up-prod.sh, npm-pkg-vers.js, nonpmproxy.sh, packagever.sh

if [ "$1" == "--help" ]; then
	USAGE=1
fi
if [ "$1" == "--man" ]; then
	USAGE=1
fi

if [ "$1" == "-?" ]; then
	USAGE=1
fi

if [ ! -z "$USAGE" ]; then
	echo "
Usage: $(basename $0) [--help|--man|-?] [options...]

This script will use the npm list command to show a diffable list of npm package dependencies.

You can specify a package name as an option to limit the listing to that package.

See 'npm help list' command output for details of the options allowed.
"
	exit 1
fi

parseable=`npm config get parseable`
npm config set parseable true
npm ll $* | perl -pne 's{\A.+?(/node_modules)}{$1}xms' | sort
npm config set parseable $parseable
