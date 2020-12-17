#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# add shebang line to file types
# WINDEV tool useful on windows development machin

EXT=${1:-*.js}
SHEBANG="${2:-/usr/bin/env node}"

EXT=${1:-*.pl}
SHEBANG="${2:-/usr/bin/env perl}"

EXT=${1:-*.sh}
SHEBANG="${2:-/bin/bash}"

#EXT=${1:-*.exs}
#SHEBANG="${2:-/usr/local/bin/elixir -r}"

for f in $EXT
do
	chmod +x $f
	SHEBANG="$SHEBANG" perl -i.bak -pne '
	if (!$body) {
		$body = 1;
		unless (m{\A\#!}xms) {
			s{\A}{\#!$ENV{SHEBANG}\n}xms
		}
	}
	' $f
	echo $f: `head -1 $f`
done
