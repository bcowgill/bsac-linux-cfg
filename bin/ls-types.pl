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

__DATA__
package BSAC::FileTypesFoundState;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

END {
	print "end ". __PACKAGE__ . "\n";
	BSAC::FileTypesFoundState->save() if $BSAC::FileTypesFoundState::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::FileTypesFoundState::CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$BSAC::FileTypesFoundState::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::FileTypesFoundState::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	my $fh;
	open($fh, '>', $BSAC::FileTypesFoundState::CLASS_FILENAME);
	my $data = join('', <DATA>);
	local $Data::Dumper::Sortkeys = $BSAC::FileTypesFoundState::DEBUG;
	local $Data::Dumper::Indent   = $BSAC::FileTypesFoundState::DEBUG;
	local $Data::Dumper::Terse    = 1;

	my $dump = Dumper $BSAC::FileTypesFoundState::STATE;
	chomp $dump;
	print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
	close($fh);
}
