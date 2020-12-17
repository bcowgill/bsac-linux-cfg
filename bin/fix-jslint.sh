#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# multiline search/replace to fix javascript lint problems
# WINDEV tool useful on windows development machine

if [ ! -z "$2" ]; then
	for FILE in $*
	do
		$0 $FILE
	done
	exit $?
fi

cp "$1" "$1.bak"
perl -e '
	use strict;
	use warnings;
	use Data::Dumper;

	local $/ = undef;
	my $q = chr(39);
	my $Q = chr(34);
	my $DEBUG = 0;

	$_ = <>;

	# one var/let/const per line instead of comma separated
	s{
	( (\s*) (var|let|const) \s* ([^;]+) \s* ; )
	}{
		fix_var_def($1, $2 || "", $3, $4)
	}xmsge;

	print $_;

	sub get_indent
	{
		my ($prefix) = @_;

		$prefix =~ s{\n}{NL}xmsg;
		print STDERR "prefix: [$prefix]\n" if $DEBUG;
		$prefix =~ s{(NL)(\s*)\z}{$1}xms;
		my $break = $prefix;
		$prefix = $2 || "";
		print STDERR "break: [$break]\n" if $DEBUG;
		print STDERR "prefix: [$prefix]\n" if $DEBUG;
		$break =~ s{NL}{\n}xmsg;

		return ($break, $prefix);
	}
	sub count_specials
	{
		my ($string) = @_;
		my %Specials = map { ($_, eval "\$string =~ tr/$_/$_/") }
			split("", qq{$q$Q`\{\}[]});

		print STDERR "specials: $string\n" if $DEBUG;
		print STDERR Dumper \%Specials if $DEBUG;
		die "unbalanced {}" if $Specials{"{"} != $Specials{"}"};
		die "unbalanced []" if $Specials{"["} != $Specials{"]"};
		die "unbalanced $q" if $Specials{$q} % 2;
		die "unbalanced $Q" if $Specials{$Q} % 2;
		die "unbalanced `" if $Specials{"`"} % 2;
		return \%Specials;
	}
	# one var/let/const per line
	sub fix_var_def
	{
		my ($def, $prefix, $var, $defs) = @_;
		my @defs = ();
		eval
		{
			my ($break, $spaces) = get_indent($prefix);
			print STDERR "defs: $defs\n" if $DEBUG;

			# x = value,
			while ($defs =~ s{
				\A \s* (\w+) \s* = \s* ([^,]+?) \s* (,|\z)
			}{}xms)
			{
				print STDERR "match [$1] [$2]\n" if $DEBUG;
				my ($symbol, $value) = ($1, $2);
				count_specials($value);
				die "complex assignment" if $value =~ m{[$q$Q`]}xms;
				push(@defs, qq{$spaces$var $symbol = $value;});
			}
			$def = $break . join("\n", @defs) if scalar(@defs);
		};
		if ($@)
		{
			warn($@) if $DEBUG;
		}
		return $def;
	}

' $1.bak > $1
