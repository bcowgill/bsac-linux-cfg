#!/bin/bash
# REACTIVATE some javascript files by un-commenting them out.
# See also deactivate.sh, debug-js-on.sh debug-js-off.sh
# WINDEV tool useful on windows development machine

# CUSTOM settings you may have to change on a new computer

for file in $*; do
	perl -i.bak -pne '
	s{\A // \s* DEACTIVATED \s* \d+ .+ \z}{}xmsge;
	s{\A //\s* \z}{\n}xmsg;
	s{\A // \s? (.+) \z}{$1}xmsg;
   s{\A (\s* jscs:(en|dis)able \w+)}{//$1}xmsg;
' $file
done
