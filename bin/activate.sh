#!/bin/bash
# REACTIVATE some javascript files by un-commenting them out.

for file in $*; do
	perl -i.bak -pne '
	s{\A // \s* DEACTIVATED \s* \d+ .+ \z}{}xmsge;
	s{\A //\s* \z}{\n}xmsg;
	s{\A // \s? (.+) \z}{$1}xmsg;
   s{\A (\s* jscs:(en|dis)able \w+)}{//$1}xmsg;
' $file
done
