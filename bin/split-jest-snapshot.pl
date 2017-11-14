#!/usr/bin/env perl
# split a jest component snapshot into one file per snapshot so it's easier to diff each test case.

my $dir = $ENV{SNAP_OUT_DIR} || '.';
local $/ = undef;
my @snaps = map { qq{$_`;\n} } split(/`;\n/, <>);
my $idx = 0;
foreach my $snap (reverse(@snaps))
{
	my $fh;
	open($fh, ">", "$dir/jest-snapshot$idx.snap");
	print $fh $snap;
	close($fh);
	++$idx;
}

__END__
A Jest snapshot looks something like this:

exports[`<CardBlock /> should render a component with a toggle control 1`] = `
<div>Component Rendered Here
</div>
`;

so we simply split on the closing `;\n after each rendered test case.

