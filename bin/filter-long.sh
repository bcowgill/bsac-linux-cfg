#/bin/bash
# filter long lines by showing ellipsis

perl -pne '
	chomp;
	$L = 1024;
	if (length($_) > $L)
	{
		$el = "…"; # ellipsis
		$_ = substr($_, 0, $L) . "$el$el$el";
	}
	$_ = "$_\n";
';

# ………
exit $?
#  …  U+2026	[OtherPunctuation]	HORIZONTAL ELLIPSIS
git grep div | filter-long.sh > grep-filter.lst
grep -E '………' grep-filter.lst | perl -pne 's{:.+\z}{\n}xmsg' | sort | uniq
grep -E '………' grep-filter.lst
