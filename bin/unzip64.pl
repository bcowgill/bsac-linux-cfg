#!/usr/bin/perl
# extract base64 encoded 'zip' files.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use MIME::Base64 qw( decode_base64 );

foreach my $file (@ARGV)
{
	print "$file:\n";
	local $/ = undef;
	open INFILE, '<', $file;
	my $buf = <INFILE>;
	close INFILE;
	$buf =~ s{
		(?:\A|\n|\x0a|\x0d\x0a) ([^:]+) :
		([^:]+) :
		(?:\n|\x0a|\x0d\x0a)  (.+?) (?:\n|\x0a|\x0d\x0a)==/\1==
	}{
		decode_file($1, $2, $3)
	}xmsge;
}

sub decode_file
{
	my ($filename, $permissions, $base64) = @_;
	print "decode $filename perms: $permissions\n";
	#print decode_base64($base64) . "\n";
	my $OUTFILE;
	open $OUTFILE, '>', $filename;
	binmode $OUTFILE;
	chmod oct($permissions) | 0600, $OUTFILE;
	print $OUTFILE decode_base64($base64);
	close $OUTFILE;
	return "";
}
