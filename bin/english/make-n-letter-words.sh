# generate english word lists by number of letters in word.

perl -MData::Dumper -ne '
chomp;
$q=chr(39);
$_ = lc($_);
s{$q}{}xmsg;
$words{length($_)}{$_} = 1;

END {
foreach my $len (keys(%words))
{
	my $fh;
	open($fh, ">", "english-words-$len.txt");
	print $fh join("\n", sort(keys(%{$words{$len}})));
	close($fh);
}
}' american-english.txt british-english.txt

