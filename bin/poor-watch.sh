#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# A poor man's version of watch for a single program file.
PROG=$1

function usage {
	local code
	code=$1

	if [ $code != 0 ]; then
		print "$code\n"
		code = 1
	fi

	echo "
$(basename $0) [--help|--man|-?] command

A very simple version of the watch command to run a program whenever you edit the single source file.

command The path to the program to run whenever it is newer than the log file.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will run a program whenever it changes.  The output from the program will be written to a log file.  Then the program will run again whenever it is newer than the log file.

See also auto-build.sh

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

if [ -z "$PROG" ]; then
	usage "You must provide the name of a program to run."
fi

PROG=$PROG perl -e '
	my $DEBUG = 0;
	my $prog = qq{$ENV{PROG}};
	my $log = qq{$prog.log};
	print qq{waiting for changes to $prog\n};
	while (1)
	{
		print qq{prog: @{[-M $prog]}\nlog: @{[-M $log]}\n} if $DEBUG;
		if (!-e $log || -M $prog < -M $log)
		{
			print "running $prog logging to $log...\n";
			system("$prog | tee $log");
		}
		sleep(5);
	}
'

exit 0
