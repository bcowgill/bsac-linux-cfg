package BSAC::FileTypesFound;
use strict;
use warnings;
use English -no_match_vars;
use Carp;
use BSAC::HashArray;

# Object which saves its state automatically but we only
# save if we changed the state.
use BSAC::FileTypesFoundState;
$BSAC::FileTypesFoundState::AUTOSAVE = 0;

my $rhState = $BSAC::FileTypesFoundState::STATE;
$rhState->{description} = {} unless exists($rhState->{description});
$rhState->{extension} = {} unless exists($rhState->{extension});
my $rhDescription = $rhState->{description};
my $rhExtension = $rhState->{extension};

sub save_extension_description
{
	my ($extension, $description) = @ARG;
	scalar(@ARG) == 2
		or croak "usage: \$obj@{[__PACKAGE__]}::save_extension_info(EXTENSION, DESCRIPTION)";

	$extension = lc($extension);

	my $description_index = BSAC::HashArray::push($rhDescription, $description);

	$rhExtension->{$extension} = {} unless exists($rhExtension->{$extension});
	my $extension_index = BSAC::HashArray::push($rhExtension->{$extension}, $description_index);
	$BSAC::FileTypesFoundState::AUTOSAVE = 1 if BSAC::HashArray::has_changes($rhExtension->{$extension});
	BSAC::HashArray::clear_changes($rhExtension->{$extension});
}

END
{
	if ($BSAC::FileTypesFoundState::AUTOSAVE
		|| BSAC::HashArray::has_changes($rhDescription))
	{
		BSAC::HashArray::clear_changes($rhDescription);
		$BSAC::FileTypesFoundState::AUTOSAVE = 1;
	}
}

1;
