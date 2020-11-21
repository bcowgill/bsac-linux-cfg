package BSAC::POF;
# A perl POF - Persistent Object File.  The object provides methods for accessing a data structure and automatically saves the current data structure when the program terminates.
# Generate a new PERL OBJECT FILE with autosave support from this template with no initial data.
# perl -pne 's{BSAC::POF}{BSAC::FileTypesFoundState}xmsg' POF.pm > FileTypesFoundState.pm
# TODO -- save to a tmp file if cannot auto-savet to itself
use strict;
use warnings;
use Carp;
use Module::Filename;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

my $data = join('', <DATA>);
close(DATA);
carp "@{[__PACKAGE__]} has no DATA, auto-save on exit will not be possible." unless length($data);

END {
	print "end ". __PACKAGE__ . "\n" if $BSAC::POF::DEBUG;
	BSAC::POF->save() if $BSAC::POF::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = Module::Filename::module_filename(__PACKAGE__);
	$BSAC::POF::CLASS_FILENAME = $INC{$filename||''} || $filename;
	unless ($BSAC::POF::CLASS_FILENAME) {
		$BSAC::POF::CLASS_FILENAME = Carp::shortmess();
		$BSAC::POF::CLASS_FILENAME =~ s{\A \s+ at \s+ (.+) \s+ line \s+ \d+ \. \s* \z}{$1}xms;
	}
	if (defined($BSAC::POF::CLASS_FILENAME) && -e $BSAC::POF::CLASS_FILENAME) {
		print "@{[__PACKAGE__]} this module lives at $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::POF::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	if (length($data))
	{
		my $fh;
		open($fh, '>', $BSAC::POF::CLASS_FILENAME);
		local $Data::Dumper::Sortkeys = $BSAC::POF::DEBUG;
		local $Data::Dumper::Indent   = $BSAC::POF::DEBUG;
		local $Data::Dumper::Terse    = 1;
		my $dump = Dumper $BSAC::POF::STATE;
		chomp $dump;
		print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
		close($fh);
	}
	else
	{
		carp "@{[__PACKAGE__]} no DATA, cannot auto-save.";
	}
}
#=== END POF - PERL OBJECT FILE - object and data combined with auto-save ability

$STATE = [
];

1;
__DATA__
package BSAC::POF;
# Generate a new PERL OBJECT FILE with autosave support from this template with no initial data.
# perl -pne 's{BSAC::POF}{BSAC::FileTypesFoundState}xmsg' POF.pm > FileTypesFoundState.pm
use strict;
use warnings;
use Carp;
use Module::Filename;
use Data::Dumper;
use autodie qw(open);

our $STATE;
our $AUTOSAVE = 1;

my $data = join('', <DATA>);
close(DATA);
carp "@{[__PACKAGE__]} has no DATA, auto-save on exit will not be possible." unless length($data);

END {
	print "end ". __PACKAGE__ . "\n" if $BSAC::POF::DEBUG;
	BSAC::POF->save() if $BSAC::POF::AUTOSAVE;
}

BEGIN {
	our $CLASS_FILENAME;
	our $DEBUG = 1;
	my $filename = Module::Filename::module_filename(__PACKAGE__);
	$BSAC::POF::CLASS_FILENAME = $INC{$filename||''} || $filename;
	unless ($BSAC::POF::CLASS_FILENAME) {
		$BSAC::POF::CLASS_FILENAME = Carp::shortmess();
		$BSAC::POF::CLASS_FILENAME =~ s{\A \s+ at \s+ (.+) \s+ line \s+ \d+ \. \s* \z}{$1}xms;
	}
	if (defined($BSAC::POF::CLASS_FILENAME) && -e $BSAC::POF::CLASS_FILENAME) {
		print "@{[__PACKAGE__]} this module lives at $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $BSAC::POF::CLASS_FILENAME\n, auto-save on exit will not be possible.";
	}
}

sub save {
	print "@{[__PACKAGE__]} save state to $BSAC::POF::CLASS_FILENAME\n" if $BSAC::POF::DEBUG;
	if (length($data))
	{
		my $fh;
		open($fh, '>', $BSAC::POF::CLASS_FILENAME);
		local $Data::Dumper::Sortkeys = $BSAC::POF::DEBUG;
		local $Data::Dumper::Indent   = $BSAC::POF::DEBUG;
		local $Data::Dumper::Terse    = 1;
		my $dump = Dumper $BSAC::POF::STATE;
		chomp $dump;
		print $fh "$data\n\$STATE = $dump;\n\n1;\n__DATA__\n$data";
		close($fh);
	}
	else
	{
		carp "@{[__PACKAGE__]} no DATA, cannot auto-save.";
	}
}
#=== END POF - PERL OBJECT FILE - object and data combined with auto-save ability
