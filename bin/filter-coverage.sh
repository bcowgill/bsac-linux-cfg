#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [test-log]

This will filter the jest or vitest test plan coverage output to hide coverage that is all zero or all 100% and make other cleanups when debugging a single test.

test-log A saved test log to process.
--man    Shows help for this tool.
--help   Shows help for this tool.
-?       Shows help for this tool.

Coverage ines like these will be hidden:

	coverage... not met:
	Coverage...does not meet
	blank.js   |  0  |  0  |  0  |  0  |
	full.js    | 100 | 100 | 100 | 100 |

DOS paths will be converted to unix like paths:

	C:\path\code
	file:///C:/path/code

See also ...

Example:

Run the tests while filtering the coverage output:

	npm run test -- --color 2>&1 | $cmd

	PLAN=src/path/App.spec.tsx
	npm run test -- --watchAll=true --runTestsByPath \$PLAN --color 2>&1 | $cmd
	npm run test -- --coverage --watch \$PLAN --color2>&1 | $cmd

Run the tests, save to log file then filter it.

	npm run test 2>&1 | tee test.log
	$cmd test.log
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	usage 1
fi

perl -ne '
	sub slash
	{
		my ($path) = @_;
		$path =~ s{\\}{/}xmsg;
		return "/c/$path";
	}

	$hide = 1 if m{coverage .+ not \s met:}xms;
	$hide = 1 if m{Coverage .+ does \s not \s meet}xms;
	$hide = 1 if m{(\|\s*(.\[[0-9;]+m)?\s*0\s*(.\[[0-9;]+m)?\s*){4}|(\|\s*(.\[[0-9;]+m)?\s*100\s*(.\[[0-9;]+m)?\s*){4}}xms;

	s{C:(\\.+\\)}{slash($1)}xmsie;
	s{/?C:}{/c/}xmsgi;
	s{(/c/)/}{$1}xmsgi;

	if (m{\A\s+at\s.+:\d+:\d+\)?\s*\z}xms)
	{
		$trace++;
		$hide = 1 if $trace > 3;
	}
	elsif ($trace)
	{
		$trace = 0;
		$hide = 0;
	}

	print unless $hide;
	$hide = 0;
' $*

exit $?

#ERR=$?
#if [ $ERR != 0 ]; then
#	usage $ERR
#fi
