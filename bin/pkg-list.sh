#!/bin/bash
# sorted list of all debian packages
dpkg --list | head -5
dpkg --list | perl -ne 'if ($. >= 6) { s{\A \w+ \s+ (\S+) .+ \z}{$1\n}xmsg; print }' | sort

