#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find-ez-sounds.sh easy find shows just name, size and time for all sound file types.
# See also find-sounds.sh, find-ez.sh, sound-play.sh, classify.sh
# WINDEV tool useful on windows development machine

find-ez () {
	local sourceDir
	sourceDir="$1"
	if which sw_vers > /dev/null 2>&1 ; then
		# MACOS
		# 1387357        8 -rwxr-xr-x    1 bcowgill         staff                 116  7 Oct 15:05 ./xbuild-screen-upper.sh
		# wav mp3 ogg mod
		pushd "$sourceDir" > /dev/null \
		&& find . -type f -ls \
		| egrep -i '\.(669|aac|aiff|am[fs]|ape|au|dmf|dsm|far|flac|it|m3u|m4[ap]|mdl|m[eo]d|midi?|mp[23]|mt[2m]|og[ag]|pls|p[st]m|s[3t]m|smp|snd|ult|umx|voc|wa?v|wma|xm)$' \
		| perl -pne '$q = chr(34); s{\A \d+ \s+ \d+ \s+ [drwx\-]+ \s+ \d+ \s+ \w+ \s+ \w+ \s+}{}xms; @x = split(/\s+/g); $size = shift(@x); $path = pop(@x); $time = join(" ", @x); $_ = "${q}$path$q\t$size\t$time\n"' \
		&& popd > /dev/null
	else
		# linux output:
		# "./diffemacs.sh"	136	2016-08-22+00:59:01.5543460410
		# wav mp3 ogg mod

		pushd "$sourceDir" > /dev/null \
		&& find . -type f -printf '"%h/%f"\t%s\t%T+\n' \
		| egrep -i '\.(669|aac|aiff|am[fs]|ape|au|dmf|dsm|far|flac|it|m3u|m4[ap]|mdl|m[eo]d|midi?|mp[23]|mt[2m]|og[ag]|pls|p[st]m|s[3t]m|smp|snd|ult|umx|voc|wa?v|wma|xm)"' \
		&& popd > /dev/null
	fi
}

find-ez "${1:-.}"
