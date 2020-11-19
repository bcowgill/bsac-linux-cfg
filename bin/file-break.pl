#!/usr/bin/env perl
# WINDEV tool useful on windows development machine
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Put a newline break between different files in a grep listing.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh

Example:

git grep MUSTDO | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $last = ':';
while (my $line = <>)
{
	$line =~ m{\A ([^:]+ :)}xms;
	$filename = $1;
	if ($last ne $filename)
	{
		print ":\n";
		$last = $filename;
	}
	print $line;
}

__END__
