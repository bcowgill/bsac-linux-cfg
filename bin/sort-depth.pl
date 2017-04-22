#!/usr/bin/env perl
# sort standard input as directory tree listing

my @lines = ();
while (my $line = <>)
{
	push(@lines, $line);
}

sub bylength
{
	my ($aDepth, $bDepth) = ($a =~ tr[/][/], $b =~ tr[/][/]);
	return ($aDepth <=> $bDepth) || (lc($a) cmp lc($b));
}

print join("", sort bylength @lines);

