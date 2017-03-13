#!/usr/bin/env perl
# show what type of files are present in direcdtories

# find . -type f | grep -v node_modules | ls-types.pl | sort -g -r
# 32: ./path/ 12 documents, 20 images

{ use 5.006; }
use strict;
use warnings;
use English -no_match_vars;
use FindBin;
use File::Spec;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;
use lib File::Spec->catfile($FindBin::Bin, 'perl');
use BSAC::FileTypes;

my $CSV = 1;
my $rhCounts = {};

while (my $line = <>)
{
	chomp $line;
	my @matches = BSAC::FileTypes::check_path($line, $rhCounts);
}

#print Dumper $rhCounts;

my @TypeHeaders = BSAC::FileTypes::get_types();
if ($CSV)
{
	my $headers = join(",", sort(@TypeHeaders));
	print "Total,$headers,Path\n";
}

foreach my $path (sort(keys(%$rhCounts)))
{
	my $total = 0;
	my $rhMatches = $rhCounts->{$path};
	my @matches = $CSV ? @TypeHeaders : keys(%$rhMatches);
	my $join = $CSV ? ',' : ', ';
	my $summary = join($join,
		map {
			my $count = $rhMatches->{$ARG} ? scalar(@{$rhMatches->{$ARG}}) : 0;
			$total += $count;
			$CSV ? $count||'' : qq{$count $ARG}
		} sort(@matches));

	if ($CSV)
	{
		print qq{$total,$summary,"$path"\n};
	}
	else
	{
		print qq{$total:\t$path $summary\n};
	}
}
