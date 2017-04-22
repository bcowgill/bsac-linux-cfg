# list props/state/types/context definitions/uses from react components
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
	} sort keys %Found)
}
' $*
