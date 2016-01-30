#!/bin/bash
# analyse the jshint maxcomplexity output for statistics
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
	foreach my $complexity (sort {$a <=> $b} keys(%hits))
	{
		my $ratio = $hits{$complexity}{hits} / $functions;
		$cumulative += $hits{$complexity}{hits};
		$hits{$complexity}{complexity} = $complexity;
		$hits{$complexity}{percent} = int(10000 * $ratio ) / 100;
		$hits{$complexity}{cumulative} = int(10000 * $cumulative / $functions) / 100;
	}
	
	$average = int(10 * $total_complexity / $functions) / 10;
	print "Functions: $functions\nAverage Complexity: $average\n";
	print "complexity\tfunctions\tpercentage\tcumulative %\n";

	# Output as tab separated table of values
	foreach my $complexity (sort {$b <=> $a} keys(%hits))
	{
		print "$complexity\t@{[$hits{$complexity}{hits}]}\t$hits{$complexity}{percent} %\t$hits{$complexity}{cumulative} %\n";
	}
	
	# Dump output as JSON
	my $rhJSON = {
		module => "MODULE",
		functions => $functions,
		average => $average,
		complexity => \%hits,
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

	print STDERR $json;
}
' < $1
