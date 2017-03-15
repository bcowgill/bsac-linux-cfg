package PerlModule;

=head1 NAME

PerlModule - A template for perl modules

=head1 SYNOPSIS

A quick overview of using the module in the common case.

	use PerlModule;

	# something class wide
	PerlModule->HANDLES;
	$obj = PerlModule->new('filename');
	$obj->accessor('filename'); # => 'filename'
	$obj->mutator('newFileName');

=head1 DESCRIPTION

C<PerlModule> is a full on description of the module.

Use podchecker to check pod syntax for your module.

=head1 EXAMPLES

=cut

{ use 5.006; }
use strict;
use warnings;
use Carp;
use English -no_match_vars;
use Module::Filename;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $VERSION = '1.00';

require Exporter;
our @ISA = ('Exporter');
our @EXPORT = qw();
our @EXPORT_OK = qw();
our @EXPORT_FAIL = qw();

BEGIN {
	my $filename = Module::Filename::module_filename(__PACKAGE__);
	our $CLASS_FILENAME = $INC{$filename||''} || $filename;
	unless ($CLASS_FILENAME) {
		$CLASS_FILENAME = Carp::shortmess();
		$CLASS_FILENAME =~ s{\A \s+ at \s+ (.+) \s+ line \s+ \d+ \. \s* \z}{$1}xms;
	}
	if (-e "$CLASS_FILENAME") {
		print "@{[__PACKAGE__]} this module lives at $CLASS_FILENAME\n";
	}
	else {
		carp "@{[__PACKAGE__]} this module does NOT live at $CLASS_FILENAME\n";
	}
	print Dumper \%INC;
}

=head1 CONSTANTS

=over

=item HANDLES C<PerlModule::THIS>

value is a published constant.

=back

=cut

use constant HANDLES => 42;

=head1 METHODS

=over

=item CONSTRUCTOR

new ($FILENAME [, $MODE [, $PERMS]])

Creates an C<PerlModule> with the options.

=cut

sub new
{
	my $type = shift;
	my $class = ref($type) || $type || __PACKAGE__;
	@ARG >= 1 && @ARG <= 3
		or croak "usage: $class->new(FILENAME [,MODE [,PERMS]])";

	my $self = {
		filename => $ARG[0],
		mode => $ARG[1],
		perms => $ARG[2],
	};

	return bless($self, $class);
}

=item IMMUTABLE ACCESSORS

=over 4

=item accessor($FIELD)

method is a property accessor.

=cut

sub accessor
{
	my ($self, $field) = @ARG;
	my $class = ref($self) || $self || __PACKAGE__;
	@ARG == 2
		or croak "usage: \$obj@{[__PACKAGE__]}->accessor(FIELD)";
	return $self->{$field};
}

=back

=item MUTATORS

=over 4

=item mutator($VALUE)

method is a class mutator.

=cut

sub mutator
{
	my ($self, $value) = @ARG;
	my $class = ref($self) || $self || __PACKAGE__;
	@ARG == 2
		or croak "usage: \$obj@{[__PACKAGE__]}->mutator(VALUE)";
	$self->{filename} = $value;
	return $self;
}

=back

=back

=cut

#===========================================================================
# PRIVATE METHODS



=head1 BUGS

Any known bugs.

=head1 CAVEATS

List any gotchas.

=head1 TO DO

=over

=item * What's left to do.

=back


=head1 AUTHOR

Brent S.A. Cowgill

=head1 COPYRIGHT and LICENSE

Copyright (c) Brent S.A. Cowgill. All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

See L<"BUGS"> to link to another part of the pod.

Perl module style guide.
L<http://perldoc.perl.org/perlmodstyle.html#NAME>

=cut

carp("Just a warning for you");
croak("Unrecoverable Error") if 0;

1;

__END__
__DATA__
