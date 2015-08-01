#!/bin/bash
# update the i3-config file for current main and aux monitors

if [ ${OUTPUT_MAIN:-error} == error ]; then
	source `which detect-monitors.sh`
fi

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi

echo updating i3 config file $OUTPUT_MAIN $OUTPUT_AUX

# update monitor variables in config file
#set $main eDP1
#set $aux HDMI1 # HOME
perl -i.bak -pne '
	s{\A \s* (set \s+ \$main \s+) .+? \n \z}{$1$ENV{OUTPUT_MAIN}\n}xms;
	s{\A \s* (set \s+ \$aux  \s+) .+? \n \z}{$1$ENV{OUTPUT_AUX}\n}xms;
' ~/bin/cfg/.i3-config
egrep 'set\s+\$(main|aux)' ~/bin/cfg/.i3-config