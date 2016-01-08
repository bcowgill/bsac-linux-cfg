#!/bin/bash
# annotate css/less files with a class name to identify the source file.
# useful when CSS is required into an app and gets shoved into a <style> element thereby obscuring where it came from.

WHERE=$(basename `pwd`) perl -i.bak -pne '
if ($ARGV ne $current) {
	$current = $ARGV;
	print STDERR "$current\n";
	$end = "\n\n";
	$end = "" if $_ =~ s{ \.source-file-less \s* \{ .* \} }{}xms;
	$_ = ".source-file-less { content: @{[chr(34)]}$ENV{WHERE}/$ARGV@{[chr(34)]}; }$end$_";
}
' `find */styles -name '*.less'`
