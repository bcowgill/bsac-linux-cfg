#!/usr/bin/env perl
# list tab/space inconsistencies in files
# export TAB_STOP=N to change tab stop size

use strict;
use warnings;
use English qw(-no_match_vars);

my $TAB_STOP = $ENV{TAB_STOP} || 4;
my $prefix_tabs = 0;
my $prefix_spaces = 0;
my $uneven_spacing = 0;
my $code = 0;

while (my $line = <>)
{
	# ignore lines with no lead spacing
	next if ($line =~ m{\A \S}xms);
	next if ($line =~ m{\A (\n|\z)}xms);
	
	# ignore lines with tabs only
	if ($line =~ m{\A \t+ (\n|\S|\z)}xms)
	{
		$prefix_tabs++;
		next;
	}

	# handle lines with lead space only
	if ($line =~ m{\A \ + (\S|\z)}xms)
	{
		$prefix_spaces++;
		show_line($line);
		next if $line =~ m{\A \ + (\n|\z)}xms;
	}
	else
	{
		# handle lines with mixed spaces and tabs
		$prefix_spaces++;
		$prefix_tabs++;
		show_line($line);
	}
}

sub show_line
{
	my ($line) = @ARG;
	$line =~ s{
		\A ([\ \t]+) (\n|\S|\z)
	}{
		mark_spacing($1) . $2;
	}xmsge;
	print "$INPUT_LINE_NUMBER $line";
}

sub mark_spacing
{
	# mark spaces '.' tabs 'T' and a tab's worth of spaces as '|..|'
	my ($prefix) = @ARG;
	$prefix =~ s{ \ {$TAB_STOP} }{ '|' . ('.' x ($TAB_STOP - 2)) . '|' }xmsge;
	$prefix =~ tr[ \t][.T];
	$uneven_spacing++ if ($prefix =~ m{\.}xms);
	return $prefix;
}

print "=====\n$INPUT_LINE_NUMBER lines read\n";
print "$prefix_spaces lines with prefix spacing\n";
print "$prefix_tabs lines with prefix tabs\n";
if ($uneven_spacing)
{
	print "spacing which mismatches tab depth (TAB_STOP=$TAB_STOP) found.\n";
	$code = 2;
}
if ($prefix_tabs && $prefix_spaces)
{
	print "mixed tabs and spaces found.\n"; 
	$code = 1;
}

print "spacing ok for tab stop $TAB_STOP\n" if $code == 0;
exit($code);
__END__
