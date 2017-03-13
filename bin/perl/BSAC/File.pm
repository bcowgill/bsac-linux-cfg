package BSAC::File;

=head1 NAME

BSAC::File - Provides access to all properties of a file in one place.

=head1 SYNOPSIS

A quick overview of using the module in the common case.

	use BSAC::File;

	# something class wide
	BSAC::File->HANDLES;
	$obj = BSAC::File->new('filename');
	$obj->accessor('filename'); # => 'filename'
	$obj->mutator('newFileName');

=head1 DESCRIPTION

C<BSAC::File> is a full on description of the module.

Use podchecker to check pod syntax for your module.

=head1 EXAMPLES

=cut

{ use 5.006; }
use strict;
use warnings;
use Carp;
use English -no_match_vars;
use Cwd;
use File::Spec;

our $VERSION = '1.00';

require Exporter;
our @ISA = ('Exporter');
our @EXPORT = qw();
our @EXPORT_OK = qw();
our @EXPORT_FAIL = qw();

=head1 METHODS

=over

=item CONSTRUCTOR

new ($FILENAME)

Creates an C<BSAC::File> from the given $FILENAME.

=cut

sub new
{
	my $type = shift;
	my $class = ref($type) || $type || __PACKAGE__;
	@ARG == 1
		or croak "usage: $class->new(FILENAME)";

	my $full_file_path = shift;
	my $is_absolute = File::Spec->file_name_is_absolute($full_file_path);
	my ($volume, $directories, $filename) = File::Spec->splitpath($full_file_path);
	my ($volume2, $directories2, $filename2) = File::Spec->splitpath($full_file_path, 'no file');
	my ($name_part, $extension) = $class->split_extension($filename);

	my $self = {
		original_path => $full_file_path,
		volume => $volume,
		directories => $directories,
        all_directories => $directories2,
		filename => $filename,
		no_filename => $filename2,
		name_part => $name_part,
		extension => $extension,
		relative_path => File::Spec->abs2rel($full_file_path),
		absolute_path => File::Spec->rel2abs($full_file_path),
        real_path => Cwd::realpath($full_file_path),
		canonpath => File::Spec->canonpath($full_file_path),
		no_upwards => File::Spec->no_upwards($full_file_path),
		filename_is_absolute => $is_absolute,
		curdir => Cwd::cwd(),
		sys_curdir => File::Spec->curdir(),
		sys_devnull => File::Spec->devnull(),
		sys_rootdir => File::Spec->rootdir(),
		sys_tmpdir => File::Spec->tmpdir(),
		sys_updir => File::Spec->updir(),
		sys_case_tolerant => File::Spec->case_tolerant(),
		sys_path => [File::Spec->path()],
	};

	return bless($self, $class);
}

sub split_extension
{
	my $type = shift;
	my $class = ref($type) || $type || __PACKAGE__;
	@ARG == 1
		or croak "usage: $class->split_extension(FILENAME)";

	my ($filename) = shift;
	my $prefix = '';
	if ($filename =~ s{ \A \. }{}xms)
	{
		$prefix = '.';
	}
	my ($name_part, $extension) = split(/\./, $filename, 2);
	return ($prefix . $name_part, $extension || '');
}

#catdir
#catfile,join
#catpath
#abs2rel $base

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

1;
