#!/usr/bin/env perl
# Convers grep-utf8.sh output to Javascript key/value/var definitions

# grep-utf8.sh hyphen | grep -ivE 'armenian|canadian|mongolian|diaeresis|katakana|oblique' | utf8-jsout.pl

my $INVERSE = $ENV{INVERSE}; # map char to name instead of name to char
my $VAR = $ENV{VAR}; # output a const instead of key/value

while (my $line = <>)
{
	chomp;
	my ($ch, $code, $type, $name) = split("\t", $line);
	$name =~ s{\s*\z}{}xms;
	my $desc = $name;
	$type =~ s{[\[\]]}{}xmsg;
	$name =~ s{[^a-z0-9]}{_}xmsgi;
	$code =~ s{\AU\+}{}xms;
	$code = qq{"\\u$code"};
	my ($indent, $def, $sep) = ("\t", ":", ",");
	if ($VAR)
	{
		$name = "export const $name";
		$indent = "";
		$def = " =";
		$sep = ";";
	}
	elsif ($INVERSE)
	{
		my $temp = $code;
		$code = qq{"$name"};
		$name = $temp;
	}
	$line = qq{$indent$name$def $code$sep // [$ch] $type $desc\n};
	print $line;
}
