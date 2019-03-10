#!/bin/bash
# fix-imports changes import X ... into require X

# TODO:IE8 must convert import X from 'Y' to const X = require(Y) everywhere
# we just regex fix it so we don't have to change the source code

if [ -z "$1" ]; then
	echo "
usage: $0 filename...

Converts ES5 style import X, { Y, ... } from Z into const X = require(Z) ... for IE8 compatibility

Fixes:
	also React.PureComponent becomes React.Component
	copyProvider.getCopy becomes resources.getResource
"
	exit 1
fi

if [ ! -z "$2" ]; then
	while [ ! -z $1 ]; do
		$0 "$1"
		shift
	done
	exit 0
fi

cp $1 $1.bak
FILENAME="$1" perl -e '
	local $/ = undef;
	my $q = chr(39); # single quote

	$_ = <>;

		# handle X as Y, Z, ...
		sub consts {
			my ($obj, $consts) = @_;
			my @Consts = map {
				my ($export, $alias) = split(/\s+as\s+/, $_);
					$alias = $alias || $export;
					"const $alias = $obj.$export;"
				}
				split(/\s*,\s*/, $consts);
			return join("\n", @Consts);
		}
		# handle a filename ../this-that/thing to var name ThisThatThing
		sub varname {
			# ./some/name-list => SomeNameList
			my ($filename) = @_;
			$filename =~ s{\.\.?/}{}xmsg;
			$filename =~ s{[-_/](.)}{uc($1)}xmsge;
			$filename = "Myself" unless length($filename);
			return ucfirst($filename);
		}
		# import Y
		s{
			((?<!/[\*/]\s)import \s* $q([^$q]+)$q)
		}{
			"// $1;\nrequire($q$2$q)"
		}xmsge;
		# import X from Y
		s{
			((?<!/[\*/]\s)import \s+ (\w+) \s+ from \s* $q([^$q]+)$q)
		}{
			"// $1;\nconst $2 = require($q$3$q)"
		}xmsge;
		# import X, { Y } from Z
		s{
			((?<!/[\*/]\s)import \s+ (\w+) \s* , \s* \{ \s* ([^\}]+?) \s* \} \s* from \s* $q([^$q]+)$q;)
		}{
			"/* $1 */\nconst $2 = require($q$4$q);\n" . consts($2, $3)
		}xmsge;
		# import { X } from Y
		s{
			((?<!/[\*/]\s)import \s* \{ \s* ([^\}]+?) \s* \} \s* from \s* $q([^$q]+)$q;)
		}{
			"/* $1 */\nconst @{[varname($3)]} = require($q$3$q);\n" . consts(varname($3), $2)
		}xmsge;
		s{(React\.)Pure(Component)}{$1$2}xmsg;
		s{copyProvider\.getCopy}{copyProvider.getResource}xmsg;

	print $_;
' $1.bak > $1
