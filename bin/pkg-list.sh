#!/bin/bash
# sorted list of all brew/debian cross-platform packages
if which brew > /dev/null; then
	brew list | sort
	exit 0
fi
dpkg --list | head -5
dpkg --list | perl -ne 'if ($. >= 6) { s{\A \w+ \s+ (\S+) .+ \z}{$1\n}xmsg; print }' | sort

