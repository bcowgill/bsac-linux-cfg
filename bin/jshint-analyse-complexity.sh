#!/bin/bash
# analyse the jshint maxcomplexity output for statistics
export MODULE=$1
export SERIES=$2
export MAX=$3
file=$4

if [ -z "$file" ]; then
	echo usage: $(basename $0) module seriesIndex maxComplexity complexityLogFile
	exit 1
fi

perl -MData::Dumper -ne '
if (m{cyclomatic \s+ complexity \s+ is \s+ too \s+ high\. \s+ \((\d+)\)}xms)
{
	my $complexity = $1;
	++$functions;
	$total_complexity += $complexity;
	++$hits{$complexity}{hits};
};

END
{
	my $squote = chr(39);
	foreach my $complexity (2 .. $ENV{MAX})
	{
		my $ratio = $hits{$complexity}{hits} / $functions;
		$cumulative += $hits{$complexity}{hits};
		$hits{$complexity}{complexity} = $complexity;
		$hits{$complexity}{percent} = (int(10000 * $ratio ) / 100);
		$hits{$complexity}{cumulative} = int(10000 * $cumulative / $functions) / 100;
		push(@values, {
			"series" => $ENV{SERIES},
			"x" => $complexity,
			"y" => $hits{$complexity}{percent},
		});
	}

	$average = int(10 * $total_complexity / $functions) / 10;
	print "Functions: $functions\nAverage Complexity: $average\n";
	print "complexity\tfunctions\tpercentage\tcumulative %\n";

	# Output as tab separated table of values
	foreach my $complexity (sort {$b <=> $a} keys(%hits))
	{
		print "$complexity\t@{[$hits{$complexity}{hits}]}\t$hits{$complexity}{percent} %\t$hits{$complexity}{cumulative} %\n" if $hits{$complexity}{percent};
	}

	# Dump output as JSON
	my $rhJSON = {
		key => "$ENV{MODULE}",
		seriesIndex => $ENV{SERIES},
		functions => $functions,
		average => $average,
		complexity => \%hits,
		values => \@values,
	};
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	$Data::Dumper::Pair = ": ";
	$Data::Dumper::Sortkeys = sub {
		my $rh = shift;
		my @keys = sort {
			# sort keys numerically then alphabetically with complexity key last
			my $A = $a eq "complexity" ? "zzzzzzzzzzzzzcomplexity": $a;
			my $B = $b eq "complexity" ? "zzzzzzzzzzzzzcomplexity": $b;
			($b <=> $a) || ($A cmp $B);
		} keys %$rh;
		return \@keys;
	};
	$json = Dumper($rhJSON);
	$json =~ s[};][}]xmsg;
	$json =~ s{\$VAR1 \s+ = \s+}{}xmsg;
	$json =~ s{"([\d.]+)"(,|\n)}{$1$2}xmsg;
	$json =~ s{undef}{null}xmsg;

	print STDERR $json;
}
' $file
