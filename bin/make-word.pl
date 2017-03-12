#!/usr/bin/env perl
# make-word.sh
# Hanging with friends game, get highest scoring words

use strict;
use warnings;
use autodie;

my $TILES = shift;
my $MULTIPLIER = shift;
my $LETTERX = 1;
my $WORDX = 1;
my $DICTIONARY = $0;

$DICTIONARY =~ s{/([^/]+)\z}{/english/british-english.txt}xmsg;
#print $DICTIONARY;

my $AT = shift || 7;
$AT =~ s{\@}{}xmsg;

if (! $TILES)
{
	print <<"USAGE";
$0 letters 2xword|2xletter \@3

find best scoring words for hanging with friends.

example:

$0 etaoinsrh 2xword \@5 | sort -g | grep -v x[2-9]

indicates a double word score tile at position 5
USAGE
	exit 1
}

if ($MULTIPLIER =~ m{w}i)
{
	$MULTIPLIER =~ m{(\d+)};
	$WORDX = $1;
}
else
{
	$MULTIPLIER =~ m{(\d+)};
	$LETTERX = $1;
}

my %V = qw( a 1 e 1 i 1 o 1 u 2   b 4 c 4 d 2 f 4 g 3 h 3 j 10 k 5 l 2 m 4 n 2 p 4 q 10 r 1 s 1 t 1 v 5 w 4 x 8 y 3 z 10 );

#print "$TILES $WORDX $LETTERX $AT\n";

my $fh;
open($fh, '<', $DICTIONARY);

while (<$fh>)
{
	chomp;
	next if length($_) > 8;
	next if length($_) < 4;
	my %C = ();
	if ($_ =~ m{\A [$TILES]+ \z}xms)
	{
		my $v = 0;
		my $w = $_;

		s{(.)}{
			++$C{$1};
			$v += $V{$1};
			qq{$1=$V{$1} };
		}xmsge;

		my $score = score($w, $v);
		print qq{$score $v $w $_ / @{[map { qq{${_}x$C{$_}} } grep { $C{$_} > 1} keys(%C)]}\n};
	}
}

sub score
{
	my ($w, $v) = @_;
	$v *= $WORDX if length($w) >= $AT;
	$v += ($LETTERX - 1) * $V{substr($w, $AT-1, 1)} if length($w) >= $AT;
	return $v;
}

