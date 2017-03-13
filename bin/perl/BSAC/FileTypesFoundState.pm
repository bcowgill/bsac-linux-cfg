package BSAC::FileTypesFoundState;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

my $data = join('', <DATA>);
close(DATA);
carp "@{[__PACKAGE__]} has no DATA, auto-save on exit will not be possible." unless length($data);

END {
	print "end ". __PACKAGE__ . "\n";
	BSAC::FileTypesFoundState->save() if $BSAC::FileTypesFoundState::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 0;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::FileTypesFoundState::CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$BSAC::FileTypesFoundState::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::FileTypesFoundState::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	if (length($data))
	{
		my $fh;
		open($fh, '>', $BSAC::FileTypesFoundState::CLASS_FILENAME);
		local $Data::Dumper::Sortkeys = $BSAC::FileTypesFoundState::DEBUG;
		local $Data::Dumper::Indent   = $BSAC::FileTypesFoundState::DEBUG;
		local $Data::Dumper::Terse    = 1;

		my $dump = Dumper $BSAC::FileTypesFoundState::STATE;
		chomp $dump;
		print $fh "$data\n\$STATE = $dump;\n\n1;\n_" . "_DATA__\n$data";
		close($fh);
	}
	else
	{
		carp "@{[__PACKAGE__]} no DATA, cannot auto-save.";
	}
}

$STATE = {};

1;
__DATA__
package BSAC::FileTypesFoundState;
use strict;
use warnings;
use Carp;
use File::Spec;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

my $data = join('', <DATA>);
close(DATA);
carp "@{[__PACKAGE__]} has no DATA, auto-save on exit will not be possible." unless length($data);

END {
	print "end ". __PACKAGE__ . "\n";
	BSAC::FileTypesFoundState->save() if $BSAC::FileTypesFoundState::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 0;
	my $filename = File::Spec->catfile(split('::', __PACKAGE__)) . '.pm';
	$BSAC::FileTypesFoundState::CLASS_FILENAME = $INC{$filename} || $filename;
	if (-e "$BSAC::FileTypesFoundState::CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::FileTypesFoundState::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::FileTypesFoundState::CLASS_FILENAME\n" if $BSAC::FileTypesFoundState::DEBUG;
	if (length($data))
	{
		my $fh;
		open($fh, '>', $BSAC::FileTypesFoundState::CLASS_FILENAME);
		local $Data::Dumper::Sortkeys = $BSAC::FileTypesFoundState::DEBUG;
		local $Data::Dumper::Indent   = $BSAC::FileTypesFoundState::DEBUG;
		local $Data::Dumper::Terse    = 1;

		my $dump = Dumper $BSAC::FileTypesFoundState::STATE;
		chomp $dump;
		print $fh "$data\n\$STATE = $dump;\n\n1;\n_" . "_DATA__\n$data";
		close($fh);
	}
	else
	{
		carp "@{[__PACKAGE__]} no DATA, cannot auto-save.";
	}
}
