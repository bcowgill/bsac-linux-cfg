#!/usr/bin/env perl
# anglicise letters with accents and such

# 'seamless' unicode support
use 5.012;
#use feature "unicode_strings";

my $ECHO = ""; # or inline, line

# replace accented characters with plain a-z
# NOTE this is an incomplete list, was only the characters
# present in the sample english word files I had downloaded
my %R = (
	a => [qw( á â ä å â )],
	A => [qw( Á Â Å Â )],
	e => [qw( è é ê )],
	E => [qw( Ë )],
	i => [qw( í )],
	I => [qw( Ì Í )],
	o => [qw( ó ô ö )],
	O => [qw( Ò Ó Ô )],
	u => [qw( û ü )],
	U => [qw( Ù Û )],
	c => [qw( ç )],
	n => [qw( ñ )],
);

while (my $line = <>)
{
	chomp($line);
	my $original = $line;

	foreach my $letter (keys(%R))
	{
		foreach my $find (@{$R{$letter}})
		{
			$line =~ s{$find}{$letter}xmsg;
		}
	}
	#tr{A-Z}{a-z};
	if ($ECHO eq "inline")
	{
		$line = "$original\t$line";
	}
	elsif ($ECHO eq "line")
	{
		$line = "$original\n$line";
	}
	print "$line\n";
}

