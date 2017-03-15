package BSAC::FileTypesFound;

=head1 NAME

BSAC::FileTypesFound - Keeps a record of file extensions and descriptions.

=head1 SYNOPSIS

	use BSAC::FileTypesFound;

	BSAC::FileTypesFound->save_extension_description('txt', 'ascii text with LF endings');

=head1 DESCRIPTION

C<BSAC::FileTypesFound> records a library of file extensions and type
descriptions that have been seen. It is a module which automatically
saves its state back to itself when the program ends.

=head1 EXAMPLES

=cut

{ use 5.006; }
use strict;
use warnings;
use English -no_match_vars;
use Carp;
use BSAC::HashArray;

our $VERSION = '1.00';

require Exporter;
our @ISA = ('Exporter');
our @EXPORT = qw();
our @EXPORT_OK = qw(save_extension_description);
our @EXPORT_FAIL = qw();

# Object which saves its state automatically but we only
# save if we changed the state.
use BSAC::FileTypesFoundState;
$BSAC::FileTypesFoundState::AUTOSAVE = 0;

my $rhState = $BSAC::FileTypesFoundState::STATE;
$rhState->{description} = {} unless exists($rhState->{description});
$rhState->{extension} = {} unless exists($rhState->{extension});
my $rhDescription = $rhState->{description};
my $rhExtension = $rhState->{extension};

=head1 METHODS

=over


=item IMMUTABLE ACCESSORS

=over 4

=item get_extensions()

gets the list of all known file extensions in the order they were seen.

NOT YET IMPLEMENTED

=cut

#sub accessor() {}

=item get_descriptions($EXTENSION)

gets the list of all known file descriptions for an $EXTENSION.

NOT YET IMPLEMENTED

=cut

#sub accessor() {}

=back

=item MUTATORS

=over 4

=item save_extension_description($EXTENSION, $DESCRIPTION)

Will record a file extension and the description so that a given extension
can have multiple descriptions.

This function can be exported for convenience.

=cut

my $count = 0;

sub save_extension_description
{
	my ($extension, $description) = @ARG;
	scalar(@ARG) == 2
		or croak "usage: \$obj@{[__PACKAGE__]}::save_extension_info(EXTENSION, DESCRIPTION)";

	$extension = lc($extension);

	print STDERR "\n\n$count $extension $description\n\n" if $count % 10 == 0;
	my $description_index = BSAC::HashArray::push($rhDescription, $description);

	$rhExtension->{$extension} = {} unless exists($rhExtension->{$extension});
	my $extension_index = BSAC::HashArray::push($rhExtension->{$extension}, $description_index);
	$BSAC::FileTypesFoundState::AUTOSAVE = 1 if BSAC::HashArray::has_changes($rhExtension->{$extension});
	BSAC::HashArray::clear_changes($rhExtension->{$extension});
	if (++$count > 100) {
		print STDERR "\n\nSAVING EXTENSIONS DATA\n\n";
		# Perform auto save if we have had any state change.
		if ($BSAC::FileTypesFoundState::AUTOSAVE
			|| BSAC::HashArray::has_changes($rhDescription))
		{
			BSAC::HashArray::clear_changes($rhDescription);
			$BSAC::FileTypesFoundState::AUTOSAVE = 1;
		}
		$count = 0;
	}
}


=back

=back

=cut

#===========================================================================
# PRIVATE METHODS

END
{
	# Perform auto save if we have had any state change.
	if ($BSAC::FileTypesFoundState::AUTOSAVE
		|| BSAC::HashArray::has_changes($rhDescription))
	{
		BSAC::HashArray::clear_changes($rhDescription);
		$BSAC::FileTypesFoundState::AUTOSAVE = 1;
	}
}

=head1 BUGS

No known bugs.

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
