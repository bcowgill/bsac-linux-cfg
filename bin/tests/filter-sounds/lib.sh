# Filter the egrep usage for cross OS compatability
function filter_egrep {
	local file
	file="$1"
	perl -i -pne '
		$q = chr(39);
		s{unrecognized}{unrecognised}xmsg;
		s{`(--(invalid|inplace))$q}{$q$1$q}xmsg;
		s{(usage:\s+e?grep).+\z}{lc($1) . " ...\n"}xmsgie;
		s{Try\s+${q}e?grep\s+--help.+\z}{}xmsg;
		s{\A\s+\[.+\z}{}xmsg;
	' $file
}
