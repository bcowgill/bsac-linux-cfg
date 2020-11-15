#!/bin/bash
# set up locale for unicode
# https://perlgeek.de/en/article/set-up-a-clean-utf8-environment

# WINDEV tool useful on windows development machine

export LANG=en_GB.UTF-8
export LANGUAGE=en_GB:en
export LC_CTYPE="$LANG"
export LC_NUMERIC="$LANG"
export LC_TIME="$LANG"
export LC_COLLATE="$LANG"
export LC_MONETARY="$LANG"
export LC_MESSAGES="$LANG"
export LC_PAPER="$LANG"
export LC_NAME="$LANG"
export LC_ADDRESS="$LANG"
export LC_TELEPHONE="$LANG"
export LC_MEASUREMENT="$LANG"
export LC_IDENTIFICATION="$LANG"
export LC_ALL=

# check the locale output is good
perl -Mcharnames=:full -CS -wle 'print "\N{EURO SIGN}"'
