#!/usr/bin/env perl
# assign-to-team.pl tests/assign-to-team/in/team.txt

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
use autodie qw(open); # mkdir rmdir unlink move opendir );

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] filename...

This will divide up story or task id's or lists among cross-functional teams created on an ad hoc basis.

filename    files to process instead of standard input.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

The files processed should define the roles and people available and the list of stories or tasks to divide up.

The format is quite simple.  A hash mark '#' comments out a line so it will be ignored.  For example if a given person is currently away.

A line that ends with a colon ':' defines a role type or begins a list of tasks to divide up.

Task lines are specified as task: tasks: story: or stories:

A line with end: stop: quit: or go: indicates that there is no more. The tasks will be divided up at this point.

Other lines will be added to the current context, either a role list or a task list.

Example:

Use existing team.txt file to divide up the tasks listed in tasks.txt

$cmd team.txt tasks.txt

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 0;
our $SKIP = 0;

my $IN = "   ";
my $NLIN = "\n$IN";
my $reEnd = qr{\A\s*(end|stop|quit|go)\s*:\s*\z}xmsi;
my $reTaskList = qr{\A\s*(tasks?|stor(y|ies))\s*:\s*\z}xmsi;
my $reRoleList = qr{\A\s*([^:]+)\s*:\s*\z}xmsi;
my $reMember = qr{\A\s*(.+)\s*\z}xmsi;
my $reBlank = qr{\A\s*(\#|\z)}xms;
my $reTrimSpace = qr{\s\s+}xms;
my $reStripRandom = qr{\A\d+:}xms;

my %Tasks = ();
my %Roles = ();
my @Teams = ();
my $context;
my $group;
my $jobs = 0;

our $TESTING = 0;
our $TEST_CASES = 10;
# prove command sets HARNESS_ACTIVE in ENV
#unless ($ENV{NO_UNIT_TESTS}) {
#	tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');
#}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

sub check_args
{
	# usage('You must provide a file matching pattern.') unless $pattern;
	# usage('You must provide a destination file name prefix.') unless $prefix;

	# failure("source [$source] must be an existing directory.") unless -d $source;
	# failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub main
{
	check_args();
	eval
	{
		say("specify 'end:' to end the input.\n");
		while (my $line = <DATA>) {
			parse($line);
		}
		while (my $line = <>) {
			parse($line);
		}
		report();
	};
	if ($EVAL_ERROR)
	{
		warn($EVAL_ERROR);
		exit 1;
	}
} # main()

sub parse
{
	my ($line) = @ARG;
	if ($line !~ $reBlank){
		chomp($line);
		debug($line, 2);
		if ($line =~ $reTaskList)
		{
			$context = 'task';
			$group = ucfirst($1);
			++$jobs;
			debug("begin $context/$group")
		}
		elsif ($line =~ $reEnd)
		{
			report();
			exit(0);
		}
		elsif ($line =~ $reRoleList)
		{
			$context = 'role';
			$group = ucfirst($1);
			debug("begin $context/$group")
		}
		elsif ($line =~ $reMember)
		{
			my $member = ucfirst($1);
			$member =~ s{$reTrimSpace}{ }xmsg;
			$member = int(rand(10)) . ":$member";
			if ($context eq 'task')
			{
				push(@{$Tasks{$group}}, $member);
			}
			else
			{
				push(@{$Roles{$group}}, $member);
			}
			debug("..add $member to $context/$group");
		}
		else
		{
			debug("...$line");
		}

	}
} # parse()

sub report
{
	make_teams();
	assign_tasks();
	print_report();
}

sub make_teams
{
	my @Roles = keys(%Roles);
	unless ($jobs)
	{
		failure("You must specify one or more task: type lines to define what needs to be done by the team.")
	}
	if (scalar(@Roles) < 1)
	{
		failure("You must specify one or more role: type lines to define the role types on the team.");
	}
	debug("Roles:" . Dumper(\@Roles), 3);
	my $team = 1;
	my $found;
	do {
		$found = 0;
		my @Team = ();
		foreach my $role_type (@Roles)
		{
			my ($got, $pick, $named) = pick_one($role_type, $Roles{$role_type});
			$found += $got;
			if ($got)
			{
				splice(@{$Roles{$role_type}}, $pick, 1);
				debug("$role_type: " . Dumper($Roles{$role_type}), 3);
				push(@Team, $named);
			}
		}
		if (scalar(@Team))
		{
			debug("SORTING Team" . Dumper(\@Team), 4);
			my @Sorted = order_items(sort(@Team));
			debug("SORTING Sorted" . Dumper(\@Sorted), 4);
			if ($found == scalar(@Roles))
			{
				push(@Teams, { number => $team++, members => \@Sorted, assigned => {} });
			}
			else
			{
				my $to_team = ($team++ - 1) % scalar(@Teams);
				push(@{$Teams[$to_team]{members}}, @Sorted);
			}
		}
	} while ($found);
	debug("Teams: ". Dumper(\@Teams), 3);
} # make_teams()

sub order_items
{
	return map { $ARG =~ s{$reStripRandom}{}xms; $ARG } @ARG;
}

sub pick_one
{
	my ($type, $raList) = @ARG;
	my $items = scalar(@$raList);
	debug("pick $type" . Dumper($raList), 4);
	my $got = 0;
	my $pick = '';
	my $named = '';
	if ($items)
	{
		$pick = int(rand($items));
		$named = "$raList->[$pick] ($type)";
		$got = 1;
	}
	debug("picked $got, $pick, $named", 4);
	return ($got, $pick, $named);
} # pick_one()

sub assign_tasks
{
	debug("Tasks:" . Dumper(\%Tasks), 3);
	my $teams = scalar(@Teams);
	my @Jobs = keys(%Tasks);
	my $number = 0;
	foreach my $type (@Jobs)
	{
		my @Items = @{$Tasks{$type}};
		foreach my $todo (@Items)
		{
			my $pick = $number++ % $teams;
			push(@{$Teams[$pick]{assigned}{$type}}, $todo);
		}
	}
	debug("Assigned: " . Dumper(\@Teams), 4);
}

sub print_report
{
	foreach my $team (@Teams)
	{
		say("\nTeam$team->{number}:\n");
		my @Jobs = keys(%{$team->{assigned}});
		say($IN . join("$NLIN", @{$team->{members}}) . "\n");
		foreach my $type (@Jobs)
		{
			say("$NLIN$type:\n");
			my @Items = order_items(@{$team->{assigned}{$type}});
			say("$IN$IN" . join("$NLIN$IN", @Items) . "\n");
		}
	}
}

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
} # tab()

sub failure
{
	my ($warning) = @ARG;
	die( "ERROR: " . tab($warning) . "\n" );
} # failure()

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;
	my $message;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	if ( $DEBUG >= $level )
	{
		$message = tab($msg) . "\n";
		if ($TESTING)
		{
			diag(qq{DEBUG: $message});
		}
		else
		{
			print $message
		}
	}
	return $message
} # debug()

sub warning
{
	my ($warning) = @ARG;
	my $message = "WARN: " . tab($warning) . "\n";
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		warn( $message );
	}
	return $message;
} # warning()

sub say
{
	my ($message) = @ARG;
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		print $message;
	}
	return $message;
}

main();

__END__
# Example data structure for files parsed:
# use hash marker to exclude people who are currently away.
# indentation optional
#front:
#	peter
#	paul
#	mary
#back:
#	fred
#	wilma
#	betty
#test:
#	george
#	elroy
#	jane
#stories:
#ID-001
#ID-002
#ID-003
#ID-004
#ID-005
#ID-006
#ID-007
# optional end marker to begin dividing tasks now
#end:
