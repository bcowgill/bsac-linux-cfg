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

$STATE = {'extension' => {'db' => {'lookup' => {'0' => 0},'changes' => 0,'list' => [0]},'sqlite-shm' => {'list' => [0],'changes' => 0,'lookup' => {'0' => 0}},'exe' => {'lookup' => {'12' => 0},'changes' => 0,'list' => [12]},'rdf' => {'changes' => 0,'lookup' => {'4' => 0},'list' => [4]},'default' => {'list' => [0],'changes' => 0,'lookup' => {'0' => 0}},'bak' => {'lookup' => {'3' => 0},'changes' => 0,'list' => [3]},'png' => {'list' => [1],'changes' => 0,'lookup' => {'1' => 0}},'url' => {'lookup' => {'9' => 0},'changes' => 0,'list' => [9]},'log' => {'lookup' => {'11' => 0},'changes' => 0,'list' => [11]},'lnk' => {'list' => [0],'lookup' => {'0' => 0},'changes' => 0},'sqlite-journal' => {'changes' => 0,'lookup' => {'0' => 0},'list' => [0]},'json' => {'lookup' => {'5' => 0},'changes' => 0,'list' => [5]},'m4a' => {'changes' => 0,'lookup' => {'7' => 0},'list' => [7]},'evernote' => {'list' => [0],'lookup' => {'0' => 0},'changes' => 0},'xml' => {'list' => [8],'lookup' => {'8' => 0},'changes' => 0},'' => {'list' => [0],'lookup' => {'0' => 0},'changes' => 0},'sqlite-wal' => {'changes' => 0,'lookup' => {'0' => 0},'list' => [0]},'dat' => {'lookup' => {'0' => 0},'changes' => 0,'list' => [0]},'mab' => {'lookup' => {'6' => 0},'changes' => 0,'list' => [6]},'js' => {'lookup' => {'2' => 0},'changes' => 0,'list' => [2]},'jpg' => {'list' => [10],'lookup' => {'10' => 0},'changes' => 0},'ini' => {'list' => [0],'changes' => 0,'lookup' => {'0' => 0}},'sqlite' => {'list' => [0],'lookup' => {'0' => 0},'changes' => 0},'katana' => {'list' => [0],'changes' => 0,'lookup' => {'0' => 0}},'default-not' => {'lookup' => {'0' => 0},'changes' => 0,'list' => [0]},'orca' => {'changes' => 0,'lookup' => {'0' => 0},'list' => [0]}},'description' => {'list' => ['application/octet-stream  data','image/png  data','application/javascript  data','application/x-trash  data','application/rdf+xml  data','application/json  data','application/x-markaby  data','audio/mp4  data','application/xml  data','application/x-mswinurl  data','image/jpeg  data','text/x-log  data','application/x-ms-dos-executable  data'],'changes' => 0,'lookup' => {'application/javascript  data' => 2,'application/json  data' => 5,'image/jpeg  data' => 10,'application/rdf+xml  data' => 4,'application/x-ms-dos-executable  data' => 12,'text/x-log  data' => 11,'image/png  data' => 1,'application/octet-stream  data' => 0,'application/x-markaby  data' => 6,'application/xml  data' => 8,'audio/mp4  data' => 7,'application/x-mswinurl  data' => 9,'application/x-trash  data' => 3}}};

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
