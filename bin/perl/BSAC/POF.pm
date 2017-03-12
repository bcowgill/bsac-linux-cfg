package BSAC::POF;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

END {
	BSAC::POF->save() if $BSAC::POF::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::POF::CLASS_FILENAME = $INC{$filename} || $filename;
	print "XX $BSAC::POF::DEBUG $BSAC::POF::CLASS_FILENAME \n";
	if (-e "$BSAC::POF::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::POF::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	my $fh;
	open($fh, '>', $BSAC::POF::CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $BSAC::POF::STATE;
	chomp $dump;
	print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
	close($fh);
}

$STATE = [
  'hello',
  'hello',
  'hello',
  'hello',
  'hello'
];

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
our $AUTOSAVE = 1;

END {
	BSAC::POF->save() if $BSAC::POF::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::POF::CLASS_FILENAME = $INC{$filename} || $filename;
	print "XX $BSAC::POF::DEBUG $BSAC::POF::CLASS_FILENAME \n";
	if (-e "$BSAC::POF::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::POF::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	my $fh;
	open($fh, '>', $BSAC::POF::CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $BSAC::POF::STATE;
	chomp $dump;
	print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
	close($fh);
}
