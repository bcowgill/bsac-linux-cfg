#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find-sum easy find shows just checksum, size, name and symlink destination

# 3730389851 48K ./IntroConversationBgrMobile.jpg
# 324824302 25B ./Logotype.js -> ../mc-demo-eu/Logotype.js

SUM=cksum

find-sum () {
	local sourceDir
	sourceDir="$1"
	if which sw_vers > /dev/null 2>&1 ; then
		# MACOS
    # -rw-r--r--@ 1 bcowgill  staff    48K 30 Apr 06:25 ./IntroConversationBgrMobile.jpg
    # lrwxr-xr-x  1 bcowgill  staff    25B  3 Jun 10:27 ./Logotype.js -> ../mc-demo-eu/Logotype.js
    # first convert to simple output size, name, target name
    # 25B ./Logotype.js -> ../mc-demo-eu/Logotype.js
    # 303B ./config.js
    # then add in checksum as prefix to line
    # 714223608 303 config.js
		pushd "$sourceDir" > /dev/null \
      && pwd | perl -pne 's{\A.+/(src/)}{$1}xms' \
      && find -s . \( -type f -o -type l \) -exec ls -lh {} \; \
      |  grep -v DS_Store \
      | perl -pne 's{\A.+?([0-9.]+[A-Z])\s+.+?\.}{$1 .}xms' \
      | SUM=$SUM perl -pne 'm{\s(\S+)}xms; my @checksum = split(/\s+/, `$ENV{SUM} $1`); $_ = qq{$checksum[0] $_}' \
      && popd > /dev/null
	else
		# linux output:
		# "./diffemacs.sh"	136	2016-08-22+00:59:01.5543460410
		pushd "$sourceDir" > /dev/null && find . \( -type f -o -type l \) -printf '"%h/%f"\t%s\t%T+\n' && popd > /dev/null
	fi
}

find-sum "${1:-.}"
