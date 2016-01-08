#!/bin/bash
# annotate css/less files with a class name to identify the source file.
# useful when CSS is required into an app and gets shoved into a <style> element thereby obscuring where it came from.

# debug-css.sh `find lib/styles -name '*.less'`

WHERE=$(basename `pwd`) perl -i.bak -pne 'if ($ARGV ne $current) { $current = $ARGV; print STDERR "$current\n"; $_ = ".source-file-less { content: @{[chr(34)]}$ENV{WHERE}/$ARGV@{[chr(34)]}; }\n\n$_"; }' $*

