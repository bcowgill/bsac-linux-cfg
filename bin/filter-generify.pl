#!/usr/bin/env perl
# remove date from config output to make generic and comparable

use strict;
use warnings;

# pad a string into a field width with spaces to right
sub right_pad
{
	my ($string, $length) = @_;
	return $string . (' ' x ($length - length($string)));
}

# pad a string into a field width by centering it. extra space at front if needed.
sub center_pad
{
	my ($string, $length) = @_;
	my ($before, $after) = (0, 0);
	if ($length > length($string))
	{
		$before = $length - length($string);
		if ($before % 2 == 0)
		{
			$before = $before / 2;
		}
		else
		{
			$before = int(($before + 1 )/ 2);
		}
		$after = $length - $before - length($string);
	}
#	print "\n centerpad $before $after @{[length($string)]} @{[$before + $after + length($string)]} $length\n";
	return ( (' ' x $before) . $string . (' ' x $after) );
}

my $ps_ef_width = 0;
while (my $line = <>)
{
	# Detect ps -ef header
	if ($line =~ m{\A ( UID \s+ ) PID \s+ PPID}xms)
	{
		$ps_ef_width = length($1);
	}

	# dmesg line
	# [Sat May  2 15:25:43 2015] Booting Linux on physical CPU 0xf00
	$line =~ s{ \[ \w+ \s+ \w+ \s+ \d+ \s+ \d+ : \d+ : \d+ \s+ \d+ \] }{[Day Mon DD HH:MM:SS YYYY]}xmsg;

	# ls -al line size then short date
	#   20 May  9 08:36
	#   20 May  9  1970
	$line =~ s{
		(\s+ \d+ \s+
		(?:Jan|Feb|Mar|Apr|May|Ju[nl]|Aug|Sep|Oct|Nov|Dec) \s+
		\d{1,2} \s+
		(?: \d{2} : \d{2}
		| \d{4})
		\s+)
	}{
		center_pad('NNN Mon DD HH:MM', length($1));
	}xmsge;

	# ps -ef line
	# www-data  2269  2265  0 07:45 ?        00:00:02 nginx: worker process
	# root      2279     1  0 07:45 tty1     00:00:00 /bin/login --
	$line =~ s{
		\A ( \S+ )   # $1
		\s*
		\s
		( # $2
		\s{0,4} \d{1,5} \s
		\s{0,4} \d{1,5}
		( \s+  # $3
		\d+ ) \s+
		\d{2}:\d{2} \s+
		( (?: \? | tty\d+ | pts/\d+ ) \s+ )  # $4
		\d{2}:\d{2}:\d{2}
		)
	}{
		my $x = "PID   PPID$3 HH:MM ${4}HH:MM:SS";
		right_pad($1, $ps_ef_width) . center_pad($x, length($2));
	}xmsge;
	print $line;
}
