#!/bin/bash
# A poor man's version of watch for a single program file.
PROG=$1

if [ -z "$PROG" ]; then
	echo You must provide the name of a program to run.
	exit 1
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
