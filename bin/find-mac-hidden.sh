#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# WINDEV tool useful on windows development machine
# https://gotoes.org/sales/Zip_Mac_Files_For_PC/What_Is__MACOSX.php

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [find options]

This will use a find command to show the extra files MacOS adds to zip archives for Mac specific purposes.  Use it after extracting a zip or other archive which was created on a Mac.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also ls-mac.sh ls-mac-apps.sh find-mac.sh find-mac-more.sh

Example:

  Delete the Mac added files after extracting a zip file.

  unzip something.zip
  $cmd -delete
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

find . -type d -name __MACOSX \
	-o -name .DS_Store \
	$*
