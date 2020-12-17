#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# interactive perl calculator supporting complex numbers, Big Integers, Big Rational and Big Float values
# WINDEV tool useful on windows development machine
perl -MMath::Trig -MData::Dumper -e '
use Math::Trig qw(:pi :radial :great_circle);
use Math::BigInt;
use Math::BigRat;
use Math::Complex;
use Math::BigFloat;

our $ECHO = $ENV{CALC_ECHO};

sub output
{
	my ($expression) = @_;
	print "$expression" if $ECHO;
	local $, = ", ";
	my $out = eval($expression);
	print "xx $out xx\n" if $ECHO > 1;
	if ($@)
	{
		print $@;
	}
	else
	{
		local *RESULT = eval($expression);
		if (@{*RESULT{ARRAY}})
		{
			print "(";
			print @{*RESULT{ARRAY}};
			print ")";
		}
		elsif ("$out" =~ m{\d i \z}xms)
		{
			# complex number result
			print "($out)";
		}
		elsif (%{*RESULT{HASH}})
		{
			my %H = %{*RESULT{HASH}};
			if (exists($H{_es})
				&& exists($H{sign})
				&& exists($H{_e})
				&& exists($H{_m})
				)
			{
				# BigFloat...
				print "($out)";
			}
			elsif (exists($H{value})
				&& exists($H{sign})
				)
			{
				# BigInt...
				print "($out)";
			}
			elsif (exists($H{_n})
				&& exists($H{sign})
				&& exists($H{_d})
				)
			{
				# BigRat...
				print "($out)";
			}
			elsif (exists($H{p_dirty})
				&& exists($H{display_format})
				&& exists($H{cartesian})
				&& exists($H{c_dirty})
				)
			{
				# Complex...
				print "($out)";
			}
			else
			{
				print "{";
				print %{*RESULT{HASH}};
				print "}";
			}
		}
		else
		{
			print "(";
			print eval($expression);
			print ")";
		}
	}
	print "\n";
}

BEGIN
{
	if (scalar(@ARGV))
	{
		output(join(" ", @ARGV));
		exit 0;
	}
}

print qq{Perl calculator\n[Type "exit" to exit, or "help" for help.]\n; };

while (<>)
{
	if (m{^\s*help}xmsi)
	{
		my @Math = qw{abs acos acosh acosec acosech acos_real acot acotan acotanh acoth acsc acsch
			arg asec asech asin asinh asin_real atan atanh atan2 cartesian_to_cylindrical
			cartesian_to_spherical cbrt cos cosh cosec cosech cot cotan cotanh coth cplx cplxe csc csch
			cylindrical_to_cartesian cylindrical_to_spherical deg2deg deg2grad deg2rad exp
			grad2deg grad2grad grad2rad great_circle_destination great_circle_direction
			great_circle_distance great_circle_midpoint great_circle_waypoint Im int log logn log10 pi pi2 pi4 pip2 pip4 rad2deg rad2grad
			rad2rad rand Re root sec sech sin sinh spherical_to_cartesian spherical_to_cylindrical
			sqrt srand tan tanh time};
		print qq{Perl math functions:\n@{[@Math]}\n};
		# http://perldoc.perl.org/Math/Trig.html
	}
	output($_);
	print "; ";
}
' $*
