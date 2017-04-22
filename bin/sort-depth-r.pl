#!/usr/bin/env perl
# sort standard input as directory tree listing by reverse depth

my @lines = ();
while (my $line = <>)
{
	push(@lines, $line);
}

sub bylength
{
	my ($aDepth, $bDepth) = ($a =~ tr[/][/], $b =~ tr[/][/]);
	return ($bDepth <=> $aDepth) || (lc($a) cmp lc($b));
}

print join("", sort bylength @lines);

