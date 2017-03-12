package BSAC::POF;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $CLASS_FILENAME;
my $DEBUG = 1;

BEGIN {
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $CLASS_FILENAME\n" if $DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $DEBUG;
	my $fh;
    open($fh, '>', $CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $STATE;
	chomp $dump;
	print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
    close($fh);
}

$STATE = [];

1;
__DATA__
package BSAC::POF;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $CLASS_FILENAME;
my $DEBUG = 1;

BEGIN {
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $CLASS_FILENAME\n" if $DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $DEBUG;
	my $fh;
    open($fh, '>', $CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $STATE;
	chomp $dump;
	print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
    close($fh);
}
