#!/bin/bash
# DEACTIVATE some javascript files by commenting them out completely
# and mark with today's date

for file in $*; do
	perl -i.bak -pne '
	BEGIN {
		our $banner = "// DEACTIVATED @{[`datestamp.sh`]}\n"
	}
	s{\A}{// }xmsg;
	s{\A//\s\n}{//\n}xmsg;
	s{// (//jscs:(en|dis)able maximumLineLength)}{$1}xmsg;
	$_ = $banner . $_;
	$banner = ""
' $file
done
