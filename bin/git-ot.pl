#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $STOP = '32246cf89b220935bca147e077f85067517aa7c6';
my %DAYS = qw(Sat 1 Sun 1 Mon 1);
my %HOURS = map { ($_, 1) } qw(09 10 11 12 13 14 15 16 17);

my $people = 0;
my $rhPeople = {
	'brent.cowgill@wipro.com' => 'Brent'
};
my $raCommits = [];
my $rhCommit = {};
my $rhWork = {};
my %Months = qw(
	Jan 01
	Feb 02
	Mar 03
	Apr 04
	May 05
	Jun 06
	Jul 07
	Aug 08
	Sep 09
	Oct 10
	Nov 11
	Dec 12
);


sub match_commit
{
	return $DAYS{$rhCommit->{'weekday'}} || !$HOURS{$rhCommit->{'hour'}};
}

while (my $line = <STDIN>)
{
	last if $line =~ m{$STOP}xms;
	if ($line =~ m{\Acommit\s+ (\S+) \s+}xms)
	{
		my $commit_hash = $1;
		if (! exists($rhCommit->{'commit'}))
		{
			$rhCommit->{'commit'} = $commit_hash;
		}
		else
		{
			if (match_commit()) {
				my $alias = $rhCommit->{'alias'};
				my $weekday = $rhCommit->{'weekday'};
				my $hour = $rhCommit->{'hour'};
				if ($DAYS{$weekday})
				{
					$rhWork->{$alias}{$weekday}++;
				}
				else
				{
					$rhWork->{'alias'}{'Late'}++;;
				}
				push(@$raCommits, $rhCommit);
			}
			$rhCommit = {};
		}
	}
	elsif ($line =~ m{\AAuthor:\s+((.+?)(<([^>]+)>)?)\s+\z}xms)
	{
		$rhCommit->{'author'} = $1;
		$rhCommit->{'name'} = $2;
		my $email = $4;
		$rhCommit->{'email'} = $email;
		my $alias = $rhPeople->{$email} || '';
		unless ($alias)
		{
			++$people;
			$alias = "Team Member $people";
			$rhPeople->{$email} = $alias;
		}
		$rhCommit->{'alias'} = $alias;

	}
	elsif ($line =~ m{\ADate:\s+(.+)\s+\z}xms)
	{
		my $date = $1;
		$rhCommit->{'date'} = $1;
		my ($weekday, $month, $day, $time, $year, $tzoffset) = split(/\s+/, $date);
		my ($hour, $minute, $second) = split(/:/, $time);
		$rhCommit->{'weekday'} = $weekday;
		$rhCommit->{'month'} = $month;
		my $month_number = $Months{$month};
		$rhCommit->{'month_number'} = $month_number;
		$rhCommit->{'day'} = $day;
		$rhCommit->{'time'} = $time;
		$rhCommit->{'hour'} = $hour;
		$rhCommit->{'minute'} = $minute;
		$rhCommit->{'second'} = $second;
		$rhCommit->{'year'} = $year;
		$rhCommit->{'tzoffset'} = $tzoffset;
		$rhCommit->{'date_searchable'} = "$year-$month_number-$day $weekday $time";
	}
}

print Dumper($raCommits);
print Dumper($rhWork);

__END__
commit 9df5d62ca1626adb913cbe29e7e0439c7fdd07b9
Author: Brent S.A. Cowgill <brent.cowgill@wipro.com>
Date:   Tue Nov 12 10:36:15 2019 +0000

    resolved In git-slay-branch.sh use git remote to prune branches
