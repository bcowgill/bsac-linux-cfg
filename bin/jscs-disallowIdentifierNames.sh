# TODO three letter vars that are not words?
# cat ~/bin/english/english-words-2.txt ~/bin/english/english-words-3.txt | jscs-disallowIdentifierNames.sh

perl -ne '
BEGIN {
	%Allow = map { ($_, 1) } qw(
		id ok idx abs alt app cwd dir env lte max min src url utc xhr
	)
}
chomp;
$Allow{$_} = 1;
sub trim {
	my ($result) = @_;
	$result =~ s{\s* \n}{\n}xmsg;
	return $result;
}
END {
	my $columns = 10;
	my $q = chr(34);
	my @az1 = ("a" .. "z");
	my @az2 = ("", "a" .. "z");
	foreach my $first (@az2) {
		foreach my $second (@az2) {
			foreach my $third (@az1) {
				my $name = $first . $second . $third;
				my $sep = scalar(@out) % $columns == 0 ? "\n        ": "";
				push(@out, "$sep$q$name$q") unless $Allow{$name};
				$Allow{$name} = 1;
			}
		}
	}
	print "    disallowIdentifierNames: [ " . trim(join(", ", @out)) . " ],\n";
}
'
