#!/usr/bin/env perl
# convert acceptance criteria from Jira story into Cucumber for Cypress

use strict;
use warnings;

sub usage
{
	my ($message) = @_;
	print "$message\n\n" if $message;
	print <<"USAGE";
STORY="JIRA-ID" FEATURE="Name of feature" $0 [file-name]

This will take the Given When Then statements of Acceptance Criteria from a Jira story and format it as Cucumber compliant code.

STORY     The story Id within jira or other tracking system.
FEATURE   The description of the feature being described.
USAGE
	exit($message ? 1 : 0);
}

my $story = $ENV{STORY} || usage('Please provide a STORY Id.');
my $feature = $ENV{FEATURE} ? "Feature: [$story] - $ENV{FEATURE}\n" : usage('Please provide a FEATURE description.');
my $print_feature = 1;
my $i = '  ';

while (my $line = <>) {
	next if $line =~ m{\A\s*\z}xms;
	next if $line =~ m{\A\s*feature}xms;
	$line =~ s{\s+}{ }xmsg;
	$line =~ s{\A\s*(feature|scenario|given|when|then|and|\@)}{ucfirst(lc($1))}xmsei;
	$line =~ s{\A\s*AC\s*(\d+)\s*}{Scenario: [$story-AC$1] }xms;
	$line =~ s{\A\@}{$i\@}xmsi;
	$line =~ s{\A(scenario:)}{\n$i\@devCWA\n$i$1}xmsi;
	$line =~ s{\A(given|when|then)}{$i$i$1}xmsi;
	$line =~ s{\A(and)}{$i$i$i$1}xmsi;
	if ($print_feature) {
		print "\n$feature";
	}
	$print_feature = 0;
	print "$line\n";
}

