package BSAC::HashArray;

=head1 NAME

BSAC::HashArray - Implement an array which can also be accessed like a hash

=head1 SYNOPSIS

A quick overview of using the module in the common case.

	use BSAC::HashArray;

	# functional interface operates on a hash ref
	my $rh = {};

	# mutators
	my $index = BSAC::HashArray::push($rh, $value);
	BSAC::HashArray::clear_changes($rh);

	# immutable accessors of the state
	my @keys = BSAC::HashArray::keys($rh);
	if (BSAC::HashArray::exists($rh, $value)) { }
	my $index = BSAC::HashArray::index($rh, $value);
	my $length = BSAC::HashArray::length($rh);
	my $value = BSAC::HashArray::get($rh, $index);
	my $changes = BSAC::HashArray::has_changes($rh);

=head1 DESCRIPTION

C<BSAC::HashArray> stores values in an array but prevents duplicate values
from being placed within it.  You can easily get the list of items which
have been added as well as check whether a value is present.

=head1 EXAMPLES

=cut

{ use 5.006; }
use strict;
use warnings;
use Carp;
use English -no_match_vars;
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

=head1 METHODS

=over

=item IMMUTABLE ACCESSORS

=over 4

=item length($OBJ)

Will return a count of the number of items stored in the array $OBJ.

=cut

sub length
{
	my ($self) = @ARG;
	scalar(@ARG) == 1
		or croak "usage: \$obj@{[__PACKAGE__]}::length(OBJ)";
	return scalar(@{$self->{list}});
}

=item keys($OBJ)

Will return an ordered list of the keys in the array $OBJ.
The order is given by what was first added to the array.
There will be no duplicated values in the returned array.

=cut

sub keys
{
	my ($self) = @ARG;
	scalar(@ARG) == 1
		or croak "usage: \$obj@{[__PACKAGE__]}::keys(OBJ)";
	return keys(@{$self->{list}});
}

=item has_changes($OBJ)

Will return undef or the number of times push() has been called.

=cut

sub has_changes
{
	my ($self) = @ARG;
	scalar(@ARG) == 1
		or croak "usage: \$obj@{[__PACKAGE__]}::has_changes(OBJ)";
	return $self->{changes};
}

=item exists($OBJ, $VALUE)

Will check if a given $VALUE is already in the $OBJ provided.

=cut

sub exists
{
	my ($self, $value) = @ARG;
	scalar(@ARG) == 2
		or croak "usage: \$obj@{[__PACKAGE__]}::exists(OBJ, VALUE)";
	return exists($self->{lookup}{$value});
}

=item index($OBJ, $VALUE)

Will return the index of a given $VALUE if it is already in the $OBJ provided.  Returns undef if it is not present in the $OBJ.

=cut

sub index
{
	my ($self, $value) = @ARG;
	scalar(@ARG) == 2
		or croak "usage: \$obj@{[__PACKAGE__]}::index(OBJ, VALUE)";
	return $self->{lookup}{$value};
}

=item get($OBJ, $INDEX)

Will return the value at the given array $INDEX into $OBJ.
Default value for $INDEX is zero.

=cut

sub get
{
	my ($self, $index) = @ARG;
	(scalar(@ARG) >= 1 || scalar(@ARG) <= 2)
		or croak "usage: \$obj@{[__PACKAGE__]}::get(OBJ, INDEX)";
	return $self->{list}[$index || 0];
}

=back

=item MUTATORS

=over 4

=item clear_changes($OBJ)

Will clear the change count.

=cut

sub clear_changes
{
	my ($self) = @ARG;
	scalar(@ARG) == 1
		or croak "usage: \$obj@{[__PACKAGE__]}::clear_changes(OBJ)";
	$self->{changes} = 0;
}

=item push($OBJ, $VALUE)

Will add a given $VALUE to the $OBJ unless it has already been added.
Retuns the index of the value within the $OBJ.

=cut

sub push
{
	my ($self, $value) = @ARG;
	scalar(@ARG) == 2
		or croak "usage: \$obj@{[__PACKAGE__]}::push(OBJ, VALUE)";
	my $index = BSAC::HashArray::index($self, $value);
	if (!defined($index)) {
		++$self->{changes};
		push(@{$self->{list}}, $value);
		$index = scalar(@{$self->{list}}) - 1;
		$self->{lookup}{$value} = $index;
	}
	return $index;
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

1;
