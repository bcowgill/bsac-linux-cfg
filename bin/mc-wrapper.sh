#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# from /usr/lib/mc/mc-wrapper.sh altered to pushd instead of cd
# use with this in your startup script:
# # Don't define aliases in plain Bourne shell
# [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] || return 0
# alias pushmc='. $HOME/bin/mc-wrapper.sh'
MC_USER=`id | sed 's/[^(]*(//;s/).*//'`
MC_PWD_FILE="${TMPDIR-/tmp}/mc-$MC_USER/mc.pwd.$$"
/usr/bin/mc -P "$MC_PWD_FILE" "$@"

if test -r "$MC_PWD_FILE"; then
	MC_PWD="`cat "$MC_PWD_FILE"`"
	if test -n "$MC_PWD" && test -d "$MC_PWD"; then
		pushd "$MC_PWD"
	fi
	unset MC_PWD
fi

rm -f "$MC_PWD_FILE"
unset MC_PWD_FILE
