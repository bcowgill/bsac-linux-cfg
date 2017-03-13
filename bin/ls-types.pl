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
use BSAC::HashArray;

# Object which saves its state automatically but we only
# save if we changed the state.
use BSAC::FileTypesFound;
$BSAC::FileTypesFound::AUTOSAVE = 0;

sub save_ext_info
{
	my ($extension, $description) = @ARG;
	my $state = $BSAC::FileTypesFound::STATE;
	$extension = lc($extension);

	$state->{description} = {} unless exists($state->{description});
	$state->{extension} = {} unless exists($state->{extension});
	my $description_index = BSAC::HashArray::push($state->{description}, $description);
}

END
{
	print "end ls-types\n";
	my $state = $BSAC::FileTypesFound::STATE;
	if (BSAC::HashArray::has_changes($state->{description})
		|| BSAC::HashArray::has_changes($state->{description}))
	{
		print "will save changes\n";
		BSAC::HashArray::clear_changes($state->{description});
		BSAC::HashArray::clear_changes($state->{extension});
		$BSAC::FileTypesFound::AUTOSAVE = 1;
	}
}

save_ext_info('csv', 'text with comma separated values');
save_ext_info('TXT', 'ascii text with CR/LF line endings');
print Dumper $BSAC::FileTypesFound::STATE;

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
