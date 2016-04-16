# TODO three letter vars that are not words?
# cat english/english-words-2.txt english/english-words-3.txt | ./jscs-disallowIdentifierNames.sh

perl -ne '
BEGIN {
	$rhAllow->{id} = 1;
	$rhAllow->{app} = 1;
	$rhAllow->{env} = 1;
}
chomp;
$rhAllow->{$_} = 1;
END {
	my $q = chr(34);
	my @az1 = ("a" .. "z");
	my @az2 = ("", "a" .. "z");
	foreach my $first (@az2) {
		foreach my $second (@az2) {
			foreach my $third (@az1) {
				my $name = $first . $second . $third;
				push(@out, "$q$name$q") unless $rhAllow->{$name};
				$rhAllow->{$name} = 1;
			}
		}
	}
	print "    disallowIdentifierNames: [ " . join(", ", @out) . " ],\n";
}
'

