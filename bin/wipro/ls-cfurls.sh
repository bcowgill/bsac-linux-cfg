# find applications on cloud foundry and show a map of name to url easier to grep
cf apps \
	| grep 'mybluemix.net' \
	| perl -pne '
	chomp;
	@F = split(/\s+/);
	$name = shift(@F);
	shift(@F);
	shift(@F);
	shift(@F);
	shift(@F);
	$line = join("\n", map { "$name: $_" } @F) . "\n";
	$_ = $line;
'
