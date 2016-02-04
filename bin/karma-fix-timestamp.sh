karma-webstorm.sh|perl -ne '
$q=chr(39);
$tab="    " x 5;
if (s[.There \s+ is \s+ no \s+ timestamp \s+ for \s+ /base/ (.+) \!.]
	[$tab\{pattern: $q$1$q, include: false\},]xmsg)
{
	print;
}
'
