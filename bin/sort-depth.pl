#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# sort standard input as directory tree listing
# WINDEV tool useful on windows development machine

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

