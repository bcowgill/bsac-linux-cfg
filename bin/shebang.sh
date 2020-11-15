#!/bin/bash
# add shebang line to file types
# WINDEV tool useful on windows development machin

EXT=${1:-*.exs}
SHEBANG="${2:-/usr/local/bin/elixir -r}"

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
