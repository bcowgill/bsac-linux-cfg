#!/bin/bash
# analyse the jshint maxcomplexity output for statistics
perl -MData::Dumper -ne '
if (m{\((\d+)\)}xms)
{
	++$functions;
	$total += $1;
	++$hits{$1}{hits};
};

END
{
	foreach my $complexity (sort {$a <=> $b} keys(%hits))
	{
	    $ratio = $hits{$complexity}{hits} / $functions;
	    $cumulative += $hits{$complexity}{hits};
		$hits{$complexity}{percent} = int(10000 * $ratio ) / 100;
		$hits{$complexity}{cumulative} = int(10000 * $cumulative / $functions) / 100;
	}
	$average = int(10 * $total / $functions) / 10;
	print "Functions: $functions\nAverage Complexity: $average\n";
	print "complexity\tfunctions\tpercentage\tcumulative %\n";
	foreach my $complexity (sort {$b <=> $a} keys(%hits))
	{
		print "$complexity\t@{[$hits{$complexity}{hits}]}\t$hits{$complexity}{percent} %\t$hits{$complexity}{cumulative} %\n";
	}
}
' < $1
