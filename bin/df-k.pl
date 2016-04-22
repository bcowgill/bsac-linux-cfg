#!/usr/bin/env perl
# fix up the df-k command a bit. alignment is screwey with big disks
# order columns better and sort by most disk used first

use strict;
use warnings;
use English;
use Data::Dumper;

my $line;
my @Widths;
my @Rows;
my %Align = (
	'Filesystem' => 'l',
	'Mounted on' => 'l',
);

my @Order = (
	5,  # Mounted on
	4,  # Use%
	3,  # Available
	2,  # Used
	1,  # 1K-blocks
	0,  # Filesystem
);

my $order_by = 4; # Use %
my $sub_order_by = 3; # Available

my $row = 0;
my @RowOrder = ();

while (my $line = <>)
{
	chomp($line);
	$line =~ s{Mounted \s on}{Mounted-on}xmsg;
	my @Row = split(/\s+/, $line);

	push(@RowOrder, $row++);

	my $idx = 0;
	foreach my $col (@Row)
	{
		$col =~ s{Mounted-on}{Mounted on}xmsg;
		$Row[$idx] = commas($col);
		my $length = length($col);
		$Widths[$idx] = 0 unless $Widths[$idx];
		$Widths[$idx] = $length unless $Widths[$idx] > $length;
		++$idx;
	}
	push (@Rows, [@Row]);
}

shift(@RowOrder);

my @SortedRows = sort {
	my $A = number($Rows[$a][$order_by]);
	my $B = number($Rows[$b][$order_by]);
	my $AA = number($Rows[$a][$sub_order_by]);
	my $BB = number($Rows[$b][$sub_order_by]);
	return $B <=> $A || $AA <=> $BB;
} @RowOrder;

#print Dumper(\@SortedRows);
#print Dumper(\@Rows);
#print Dumper(\@Widths);

output_row($Rows[0]);
foreach my $idx (@SortedRows)
{
	output_row($Rows[$idx]);
}

sub number
{
	my ($number) = @ARG;
	$number =~ tr{,}{} ;
	$number =~ m{\A (\d+)}xms;
	$number = $1 || 0;
	return $number;
}

sub commas
{
	my ($number) = @ARG;
	if ($number =~ m{\A \d+ \z}xms)
	{
		$number =~ s{(?<=\d)(?=(\d\d\d)+(?!\d))}{,}g;
	}
	return $number;
}

sub output_row
{
	my ($raRow) = @ARG;
	for (my $idx = 0; $idx < scalar(@$raRow); ++$idx)
	{
		my $output_idx = $Order[$idx];
		my $column = $Rows[0][$output_idx];
		my $align = $Align{$column} || 'r';
		print align($raRow->[$output_idx], 1 + $Widths[$output_idx], $align) . ' ';
	}
	print "\n";
}

sub align
{
	my ($message, $width, $alignment) = @ARG;
	$message = ($alignment && $alignment eq 'r') ? align_right($message, $width) : align_left($message, $width);
	return $message;
}

sub align_left
{
	my ($message, $width) = @ARG;
	$message .= (' ' x ($width - length($message)));
	return $message;
}

sub align_right
{
	my ($message, $width) = @ARG;
	$message = (' ' x ($width - length($message))) . $message;
	return $message;
}

__END__
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1            307591508   9435376 282531316   4% /
none                  12364152       292  12363860   1% /dev
none                  12368688       144  12368544   1% /dev/shm
none                  12368688      1404  12367284   1% /var/run
none                  12368688         0  12368688   0% /var/lock
none                  12368688         0  12368688   0% /lib/init/rw
/dev/sdb1            1922858352   7506276 1817676476   1% /data
/dev/sda5             96124904  85215480   6026472  94% /home
/dev/sda6             96124904    192176  91049776   1% /work
