#!/usr/bin/env perl
# filter out man page magic characters and the TODO section

my $ESC = chr(27);
my $BS  = chr(8);

my $skip = 0;
my $header = 1;

while (<>)
{
	s{$ESC \[ [01]m }{}xmsg;
	s{.$BS}{}xmsg;

	if (m{\ANAME}xms)
	{
		$header = 0;
	}
	if (m{\ATODO}xms)
	{
		$skip = 1;
	}
	print unless ($skip || $header);
}