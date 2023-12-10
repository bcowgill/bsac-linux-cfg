#!/usr/bin/env perl
use strict;
use warnings;

# convert letters to their phonemes...
# MUSTDO was a work in progress trying to re-spell english words according to their actual phonetics
#
#
my %Alphabet = (
	# at short
	A => 'a', # age long -- ay
	B => 'b', # bat -- bee
	C => 's', # sat -- see
	# chat
	D => 'd', # dog -- dee
	# every short
	E => 'e', # eel -- eey
	F => 'f', # fat -- ef
	G => 'g', # gap -- jee
	H => 'h', # hat -- aytch
	I => 'i', # isle -- iy (eye)
	# if
	J => 'j', # jam -- jay
	K => 'k', # king -- kay
	L => 'l', # lamb -- el
	M => 'm', # man -- em
	N => 'n', # nab -- en
	O => 'o', # own -- ow
	# ox
	P => 'p', # pig -- pee
	Q => 'kw', # quick -- kyu (cue)
	R => 'r', # rat -- ar
	S => 's', # sat -- ess
	# ass
	T => 't', # tat -- tee
	# thing
	# this
	U => 'u', # usury, ooze -- yu (you)
	# up
	V => 'v', # vat -- vee
	W => 'w', # war -- dubilyu (double u)
	X => 'ks', # exit -- eks
	Y => 'y', # young -- wi (why)
	Z => 'z', # zap -- zee
);
