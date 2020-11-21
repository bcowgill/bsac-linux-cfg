#!/usr/bin/env perl
# WINDEV tool useful on windows development machine

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
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file ...]

This is the engine behind the ls-types.sh command which you probably want to run instead.

# find . -type f | grep -v node_modules | ls-types.pl | sort -g -r
# 32: ./path/ 12 documents, 20 images

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Show what type of files are present in the direcdtories provided on standard input or from listing files.

See also ls-types.sh, whatsin.sh

Example:

echo filename | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $CSV = 1;
my $rhCounts = {};

while (my $line = <>)
{
	print STDERR $line;
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

__END__
