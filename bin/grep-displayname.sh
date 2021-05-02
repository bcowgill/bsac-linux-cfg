#!/bin/bash
# Find all React components with propTypes but missing displayName
git grep -E '(\.displayName|\.propTypes) *=' \
	| perl -ne '
	s{\A([^:]+):}{}xms;
	my $file = $1;
	if (m{displayName}xms)
	{
		$found{$file}++;
	}
	elsif (m{propTypes})
	{
		if ($found{$file})
		{
			$found{$file}--;
		}
		else
		{
			print qq{$file: Missing displayName for $_};
		}
	}
	else
	{
		print STDERR qq{unknown: $file: $_}
	}
'
