#!/usr/bin/env perl
# divide or split a listing of files into N separate lists.  Like dealing a deck of cards.

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use File::Slurp qw(:std :edit);
use autodie qw(open);
use FindBin;

our $VERSION = 0.1;
our $DEBUG = 0;

my $hands = 2;
my $rhDeal = {};
my @Outputs;


if (scalar(@ARGV))
{
	usage() if $ARGV[0] eq '--help';
	if ($ARGV[0] =~ m{\A\d+\z}xms)
	{
		$hands = shift;
	}
	my $fileName = shift;
	$fileName = '' if $fileName && $fileName eq '-';
	if (scalar(@ARGV))
	{
		@Outputs = @ARGV;
		$hands = scalar(@Outputs);
	}
	deal_file($fileName);
}
else
{
	deal_file();
}
output_hands();

sub deal_file
{
	my ($fileName) = @ARG;
	debug("deal_file [@{[$fileName||'']}]");
	my $rContent;
	if ($fileName)
	{
		$rContent = read_file( $fileName, scalar_ref => 1 );
	}
	else
	{
		$rContent = read_file( \*STDIN, scalar_ref => 1 );
	}
	my $lineNumber = 0;
	my @lines = split(/\n/, $$rContent);
	while (my $line = shift(@lines))
	{
		push(@{$rhDeal->{$lineNumber++ % $hands}}, $line);
	}
	print Dumper($rhDeal) if $DEBUG;
}

sub output_hands
{
	debug('output_hands');
	if (scalar(@Outputs))
	{
		output_files();
	}
	else
	{
		output_stdout();
	}
}

sub output_files
{
	foreach my $key (sort(keys(%$rhDeal)))
	{
		my $fh;
		open($fh, '>', $Outputs[$key]);
		print $fh join("\n", @{$rhDeal->{$key}}, '');
		close($fh);
	}
}

sub output_stdout
{
	foreach my $key (sort(keys(%$rhDeal)))
	{
		print join("\n", qq{# part @{[1 + $key]}}, @{$rhDeal->{$key}}, "\n");
	}
}

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

sub warning
{
	my ($warning) = @ARG;
	warn( "WARN: " . tab($warning) . "\n" );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	print tab($msg) . "\n" if ( $DEBUG >= $level );
}

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	print "$msg\n\n" if $msg;
	print <<"USAGE";
usage: $cmd [--help] [N] [filename] [output ...]

Divide or split a list of items into N separate lists.  Like dealing a deck of cards to N people.

N           optional. defaults to two.
filename    optional. the file containing the list of items. '-' means standard input. defaults to standard input.
output      optional names of files to create for the dealt items.

If no output file names are given the list is simple printed out with blank lines between them and a # comment to identify which number it is.

When output file names are given then the number of files determines how many hands to deal.

USAGE
	exit($msg ? 1: 0);
}
