#!/usr/bin/perl
# Create a self-extracting base64 encoded 'zip' file for sending files with dodgy characters over email.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;

use MIME::Base64 qw( encode_base64 );

local $/ = undef;
my $unpacker = <DATA>;
close(DATA);
print "$unpacker\n__DA" . "TA__\n";
foreach my $file (@ARGV) {
	my $perms = sprintf("%04o", 07777 & ((stat($file))[2]));
	print "$file:$perms:\n";
	open INFILE, '<', $file;
	binmode INFILE;
	my $buf;
	while ( read( INFILE, $buf, 4096 ) ) {
		print encode_base64($buf);
	}
	print "\n==/$file==\n";
	close INFILE;
}
__DATA__
#!/usr/bin/env perl
use strict;
use warnings;
use MIME::Base64 qw( decode_base64 );

local $/ = undef;
my $buf = <DATA>;
close(DATA);
$buf =~ s{
	(?:\A|\n|\x0a|\x0d\x0a) ([^:]+) :
	([^:]+) :
	(?:\n|\x0a|\x0d\x0a) (.+?) (?:\n|\x0a|\x0d\x0a)==/\1==
}{
	decode_file($1, $2, $3)
}xmsge;

sub decode_file
{
	my ($filename, $permissions, $base64) = @_;
	print "decode $filename perms: $permissions\n";
	my $OUTFILE;
	open $OUTFILE, '>', $filename;
	binmode $OUTFILE;
	chmod oct($permissions) | 0600, $OUTFILE;
	print $OUTFILE decode_base64($base64);
	close $OUTFILE;
	return "";
}
