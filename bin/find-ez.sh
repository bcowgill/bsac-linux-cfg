#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find-ez easy find shows just name, size and time
# WINDEV tool useful on windows development machine

find-ez () {
	local sourceDir
	sourceDir="$1"
	if which sw_vers > /dev/null 2>&1 ; then
		# MACOS
		# 1387357        8 -rwxr-xr-x    1 bcowgill         staff                 116  7 Oct 15:05 ./xbuild-screen-upper.sh
		pushd "$sourceDir" > /dev/null && find . -type f -ls | perl -pne '$q = chr(34); s{\A \d+ \s+ \d+ \s+ [drwx\-]+ \s+ \d+ \s+ \w+ \s+ \w+ \s+}{}xms; @x = split(/\s+/g); $size = shift(@x); $path = pop(@x); $time = join(" ", @x); $_ = "${q}$path$q\t$size\t$time\n"' && popd > /dev/null
	else
		# linux output:
		# "./diffemacs.sh"	136	2016-08-22+00:59:01.5543460410
		pushd "$sourceDir" > /dev/null && find . -type f -printf '"%h/%f"\t%s\t%T+\n' && popd > /dev/null
	fi
}

find-ez "${1:-.}"
