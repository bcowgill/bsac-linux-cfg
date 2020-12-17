#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# list props/state/types/context definitions/uses from react components
# WINDEV tool useful on windows development machine
for file in $*
do
	if [ ! -e $file ]; then
		file=app/components/$file/$file.jsx
	fi
	perl -ne '
	s{
		(types|props|state|context)\.(\w+)
	}{
		my $type = $1 eq "types" ? "PropTypes" : $1;
		$Found{$2}{$type} = 1
	}xmsge;

	END {
		print join("\n", map {
			".$_\t" . join(",", sort(keys %{$Found{$_}}))
		} sort keys %Found) . "\n"
	}
	' $file
done
