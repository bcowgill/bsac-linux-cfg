#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] find-key new-key [new-value] file...

This will insert a new key/value in multiple JSON files before the key found.

find-key  The JSON key name to find and insert the new key before.
new-key   The new JSON key name to add to the file.
new-value optional string value to assign to the new JSON key.  Empty string if omitted.
file      The JSON files to make changes to.
--man     Shows help for this tool.
--help    Shows help for this tool.
-?        Shows help for this tool.

Assumes the JSON is pretty formatted with a single key value per line.

The find-key will be looked for as: \"find-key\":

The new line inserted will be: \"new-key\": \"new-value\",

If the find-key isn't found the new key will be inserted before the closing }

If the new-key already exists it will be updated.

If the prettier command is on the path then it will be run to clean up the files afterwards.

See also json-plus.pl json-minus.pl json-change.sh json-insert.sh json-common.pl json-translate.pl json-reorder.pl csv2json.sh json_pp json_xs jq

Example:

$cmd paragraph1 section2 *.json

will insert a new section2 key with an empty string before the paragraph1 key.
"
	exit $code
}

if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ -z "$2" ]; then
	usage 0
fi

FIND=$1
NEW=$2
VALUE=$3
shift
shift
# Fix up if VALUE omitted in favour of a file
if [ -e "$VALUE" ]; then
  VALUE=
else
  shift
fi

if [ -z "$1" ]; then
	usage 0
fi

echo Will insert or update \"$NEW\": \"$VALUE\" before key \"$FIND\": in all files specified.
DEBUG=$DEBUG FIND="$FIND" NEW="$NEW" VALUE="$VALUE" perl -i -pne '
  BEGIN { $fileName = $ARGV[0]; }
  my $DEBUG= $ENV{DEBUG};
  ++$something;
  ++$pos;
  print STDERR "$fileName: something: $something keys: $keys has: $has found: $found\n" if $DEBUG;
  print STDERR "$pos line: $_" if $DEBUG;
  my $new = qq{  "$ENV{NEW}": "$ENV{VALUE}"};
  if (m{"\s*:\s*"}) {
     $keys++;
  }
  if (m{"$ENV{NEW}":})
  {
    $has++;
    if ($has > 1)
    {
      print STDERR "$fileName: line $pos: duplicate new key found $_";
      exit 2;
    }
    $_ = "$new,\n";
  };
  if (m{"$ENV{FIND}":})
  {
    $found++;
    if ($found > 1)
    {
      print STDERR "$fileName: line $pos: duplicate find key found $_";
      exit 3;
    }
    $_ = $has ? $_ : "$new,\n$_";
  };
  if (m[\A\s*(\{\s*)?\}\s*\z]xms)
  {
    print STDERR "end JSON\n" if $DEBUG;
    my $oneline = m[\A\s*\{\s*\}\s*\z]xms;
    if ($oneline)
    {
      print "{\n";
      $_ = "}\n";
    }
    if (!$found)
    {
      chomp;
      my $join = $keys ? ",\n" : "";
      $_ = "$join$new\n$_";
    }
    $has = 0;
    $found = 0;
    $pos = 0;
    $fileName = $ARGV[0];
  }
  END {
    print STDERR "END something: $something keys: $keys found: $found\n" if $DEBUG;
    exit 1 unless $something
  }
' $*
if [ 0 == $? ]; then
  if which prettier > /dev/null; then
    prettier --parser json --write $*
  fi
else
  exit $?
fi
