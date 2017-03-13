package BSAC::FileTypesFound;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $VAR1;
our $AUTOSAVE = 1;

END {
	BSAC::FileTypesFound->save() if $BSAC::FileTypesFound::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::FileTypesFound::CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$BSAC::FileTypesFound::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::FileTypesFound::CLASS_FILENAME\n" if $BSAC::FileTypesFound::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::FileTypesFound::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::FileTypesFound::CLASS_FILENAME\n" if $BSAC::FileTypesFound::DEBUG;
	my $fh;
	open($fh, '>', $BSAC::FileTypesFound::CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $BSAC::FileTypesFound::VAR1;
	chomp $dump;
	$dump =~ s{\A \$VAR1 \s* = \s*}{\$VAR1 = }xmsg;
	print $fh "$data\n$dump;\n\n1;\n__DATA__\n$data";
	close($fh);
}

$VAR1 = {};

1;
__DATA__
package BSAC::FileTypesFound;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $VAR1;
our $AUTOSAVE = 1;

END {
	BSAC::FileTypesFound->save() if $BSAC::FileTypesFound::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::FileTypesFound::CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$BSAC::FileTypesFound::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::FileTypesFound::CLASS_FILENAME\n" if $BSAC::FileTypesFound::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::FileTypesFound::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::FileTypesFound::CLASS_FILENAME\n" if $BSAC::FileTypesFound::DEBUG;
	my $fh;
	open($fh, '>', $BSAC::FileTypesFound::CLASS_FILENAME);
	my $data = join('', <DATA>);
	my $dump = Dumper $BSAC::FileTypesFound::VAR1;
	chomp $dump;
	$dump =~ s{\A \$VAR1 \s* = \s*}{\$VAR1 = }xmsg;
	print $fh "$data\n$dump;\n\n1;\n__DATA__\n$data";
	close($fh);
}
