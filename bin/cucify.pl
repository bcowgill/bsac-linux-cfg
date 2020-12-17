#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# convert acceptance criteria from Jira story into Cucumber for Cypress
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin;

my $DEBUG = 0;

sub usage
{
	my ($message) = @ARG;
	my $cmd = $FindBin::Script;

	print "$message\n\n" if $message;
	print <<"USAGE";
$cmd [--help|--man|-?] --ask [file-name] > cypress/integration/PAYO4B-NNN-description.dev.feature
or
STORY="JIRA-ID" FEATURE="Name of feature" $cmd [file-name]

This will take the Given When Then statements of Acceptance Criteria from a Jira story and format it as Cucumber compliant code.

--ask     If specified, will ask for the story Id and Feature description.
file-name optional. Name of file to read cucumber text from.
STORY     The story Id within jira or other tracking system.
FEATURE   The description of the feature being described.
--help    Shows help for this program.
--man     Shows help for this program.
-?        Shows help for this program.
USAGE
	exit($message ? 1 : 0);
}

my $story;
my $feature;

sub make_feature
{
	my ($story, $description) = @ARG;
	return "Feature: [$story] - $description";
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

if (($ARGV[0] || '') eq '--ask')
{
	shift;
	print STDERR "STORY ID (i.e. PAYO4B-1234) ? ";
	$story = <STDIN>;
	chomp($story);
	print STDERR "Feature Description (i.e. Make Multiple Payment) ? ";
	$feature = <STDIN>;
	chomp($feature);
	$feature = make_feature($story, $feature);
}
else
{
	$story = $ENV{STORY} || usage('Please provide a STORY Id.');
	$feature = $ENV{FEATURE} ? "Feature: [$story] - $ENV{FEATURE}" : usage('Please provide a FEATURE description.');
}
print STDERR "Paste or type acceptance criteria for story and then Ctrl-D\n";

if ($DEBUG)
{
	print "STORY=$story\nFEATURE=$feature\n";
	exit 1;
}

my $print_feature = 0;
my $i = '  ';
my $b = '*'; # to make parts bold for Jira

$b = ''; # no bold, please

while (my $line = <>) {
	next if $line =~ m{\A\s*\z}xms;
	next if $line =~ m{\A\s*feature}xms;
	$line =~ s{\s+}{ }xmsg;
	$line =~ s{\A\s*(feature:?|scenario:?|given|when|then|and|\@)}{ucfirst(lc($1))}xmsei;
	$line =~ s{\A\s*AC\s*(\d+)\s*}{Scenario: [$story-AC$1] }xms;
	$line =~ s{\bAC\s*(\d+)}{AC$1}xms;
	$line =~ s{\A\@}{$i\@}xmsi;
	$line =~ s{\A(scenario)\s*\d+\s*:}{$1:}xmsgi;
	$line =~ s{\A(scenario)\s*\[}{$1: [}xmsgi;
	$line =~ s{\A(scenario:)}{\n$i\@devCWA\n$i\@skip\n$i$1}xmsi;
	$line =~ s{\A(given|when|then)}{$i$i$b$1$b}xmsi;
	$line =~ s{\A(and)}{$i$i$i$b$1$b}xmsi;
	$line =~ s{[\ \t]+(scenario.+)\s*\z}{$i$b$1$b}xmsi;
	$line =~ s{(\[.+?\])}{$b$1$b}xmsg;
	$line =~ s{[\ \t]+(\n|\z)}{$1}xmsg;
	if ($print_feature) {
		print "\n$b$feature$b\n";
	}
	$print_feature = 0;
	print "$line\n";
}

__END__
