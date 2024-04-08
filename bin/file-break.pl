#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);

use FindBin;

sub usage
{
	my ($code) = @ARG;
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Put a newline break between different files in a grep listing.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Will actually insert a newline and a colon : to break up the grep output listing.

See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh

Example:

git grep Errors | $FindBin::Script

USAGE
	exit($code || 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my @Options = grep { m{\A-}xms } @ARGV;
if (scalar(@Options)) {
	print "Unsupported option(s) @{[join(', ', @Options)]}\n\n";
	usage(1);
}

my $last = ':';
while (my $line = <>)
{
	$line =~ m{\A ([^:]+ :)}xms;
	my $filename = $1;
	if ($last ne $filename)
	{
		print ":\n";
		$last = $filename;
	}
	print $line;
}

__END__
