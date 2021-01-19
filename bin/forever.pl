#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Output the same thing forever in 1MB chunks.  Useful for testing file operations on a full device.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my @default = qw(I swear by my life and my love of it never to live for the sake of another man nor ask another man to live for the sake of mine.);

my $mb = 1024 * 1024;
my $MAX = 4 * 1024 * $mb;
my $NL = "\n"; # " "

my $length = 0;
my $output = join(' ', @ARGV || @default) . $NL;
$output = $output x (int($mb / length($output)));
my $chunk = length($output);

do {
	print $output;
	$length += $chunk;
	die "Maximum size $MAX reached" if ($MAX && $length >= $MAX);
} while (1);

__END__
