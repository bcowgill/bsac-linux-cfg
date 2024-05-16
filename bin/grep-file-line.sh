#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [filename]

This will grep for filename, line, column and text context from a variety of output log formats from a file or standard input.

filename optional. A saved log file containing filename, line and columns in various formats.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Supports output from the grep -n command, perl script die, carp, croak and other erros, Test Anywhere Protocol (TAP) prove command. Also handles node console.trace and thrown errors.  Handles jest junit test runner output.

See also ...

Example:

	Lint the project and show files and lines with issues.
npm run lint 2>&1 | $cmd

	Save output from a unit test run then grep for referenced files and line numbers.

jest 2>&1 | tee tests.log
$cmd tests.log
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
	echo ""
	usage 1
fi

perl -ne '
	my $DEBUG = 0;
	sub slash
	{
		my ($path) = @_;
		$path =~ s{\\}{/}xmsg;
		return $path;
	}

	sub show
	{
		my ($id, $previous, $file, $line, $column, $context) = @_;

		print STDERR "line:[$line]\n" if $DEBUG;
		print STDERR "col:[$column]\n" if $DEBUG;
		print STDERR "ctx1:[$context]\n" if $DEBUG;

		$file =~ s{//+}{/}xmsg;
		$file =~ s{/\./+}{/}xmsg;
		my $message = "$file:$line:$column:";
		$message =~ s{::+}{:}xmsg;

		if ($context =~ m{\A \s* \#? \s* \z}xms)
		{
			my $prv = $DEBUG ? "prv: " : "";
			$context = "$prv$previous";
			chomp $context;
		}
		my $ID = $DEBUG ? "$id>" : "";
		print "$ID$message $context\n";
		die "next\n";
	}

	eval {

	# Correct DOS paths first:  C:\path\to\src
	if (s{\A \s* ([A-Z]) : (\\ [^:]+) }{"/" . lc($1) . "/" . slash($2)}xmse)
	{
		# /c/some/long/path/src/ fixed up...
		s{\A .+ / (src/)}{$1}xms;
		$last_file = $_;
		chomp($last_file);
		#print STDERR "LAST: $last_file\n";
	}

	my $previous = $Lines[-1] || "";

	#===  Match the current line...
	# perl at filename line NN
	show(1.0, $previous, $2, $3, $4, $1) if m{\A \s* (.+?) \s+ at \s+ (.+?) \s+ line \s+ (\d+) (?:.+col(?:umn)? \s+ (\d+))?}xms;

	# node stack trace
	# Trace: console.trace message here
	# at Object.<anonymous> (/home/me/workspace/play/bsac-linux-cfg/bin/tests/grep-file-line/x1.js:7:9)
	# at bootstrap_node.js:496:3
	my $stack_trace = $previous =~ m{\A \s* at \s+}xms ? "stack trace" : $previous;
	my $context = $previous =~ m{\A \s* at \s+}xms ? "" : " $previous";
	chomp $context;
	show(1.1, $stack_trace, $2, $3, $4, "[$1]$context") if (m{\A \s* at \s+ (.+) \s+ \( ([^:]+) : (\d+) : (\d+) \)}xms);
	show(1.2, $stack_trace, $1, $2, $3, "") if m{\A \s* at \s+ ([^:]+) : (\d+) : (\d+)}xms;

	# prettier error indication
	# [error] xx.json: SyntaxError: Unexpected token (2:3)
	show(1.3, $previous, $1, $3, $4, $2) if m{\[error\] \s+ ([^:]+) : \s+ (.+) \( (\d) : (\d+) \) \s* \n}xms;

	# eslint output with last filename recorded
	# C:\d\projects\your-details-ui\src\components\userRoles\test\UserRoles.test.tsx
	#   30:13  warning 'queryByText' is assigned a value but never used @typescript-eslint/no-unused-vars
	if ($last_file)
	{
		if (m{\A \s+ (\d+) : (\d+) \s+ (.+?) \s+ (\@?[/\w-]+) \n \z}xms)
		{
			my ($row, $column, $reason, $type) = ($1, $2, $3, $4);
			show(1.4, $previous, $last_file, $row, $column, "$reason // eslint-disable-next-line $type");
		}
	}

	# tsc type checker
	# src/utils/helpers/LBGAnalyticsHelper.ts(70,5): error TS7006: Parameter 'JourneyStatus' implicitly has an 'any' type.
	show(1.5, $previous, $1, $2, $3, $4) if m{\A ([^\(]+) \( (\d+) , (\d+)
\): \s+ (.+) \s* \n}xms;

	# grep -n output...
	show(1.999, $previous, $1, $2, $3, $4) if m{\A ([^:\s]+) : (\d+) (?: : (\d+) )? : \s* (.+?) \s* \z}xms;

	#=== Match the last two lines...

	# perl test plan terminated by error...
	my $last_two = "$previous$_";
	show(2.0, $last_two, "$4/$2", $5, $6, "$1 $3") if $last_two =~ m{\A (.+ test \s+ plan) \s+ (.+?) \s+ (terminated .+?) \s* in \s+ ([^\n]+) \n .+ on \s+ or \s+ near \s+ line \s+ (\d+) (?:.+col(?:umn)? \s+ (\d+))?}xms;

	#=== Match the last 10 lines if needed...

	# jest visual indication of error line...
	#   42 |    const...
	#   43 |    const...
	# > 44 |    const...
	if (m{\A \s+ > \s+ (\d+) \s+ \| \s+}xms)
	{
		my $line = $1;
		my $last_ten = join("", @Lines[-10 .. -1]);

		if ($last_ten =~ m{(FAIL) \s+ (.+?) \n \s* (.+?) \s+ \d+ \s+ \| \s+}xms)
		{
			my $file = $2;
			my $context = "$1 $3";
			print STDERR "ctx0:[$context]\n" if $DEBUG;
			$context =~ s{\n\s*}{ }xmsg;
			print STDERR "ctxA:[$context]\n" if $DEBUG;
			show(10.0, "previous", $file, $line, "", $context);
		}
	}

	};
	if ($@) {
		die $@ unless $@ eq "next\n";
	}
	push(@Lines, $_);
' $*
