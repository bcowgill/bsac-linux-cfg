#!/bin/bash

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

The find-key will be looked for as: "find-key":

The new line inserted will be: "new-key": "new-value",

If the find-key isn't found the new key will be inserted before the closing }

If the prettier command is on the path then it will be run to clean up the files afterwards.

See also json-plus.pl json-minus.pl json-insert.sh json-common.pl csv2json.sh json_pp json_xs jq

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

echo Will insert \"$NEW\": \"$VALUE\" before key \"$FIND\": in all files specified.
DEBUG=$DEBUG FIND="$FIND" NEW="$NEW" VALUE="$VALUE" perl -i -pne '
  my $DEBUG= $ENV{DEBUG};
  print STDERR "something: $something keys: $keys found: $found\n" if $DEBUG;
  print STDERR "line: $_" if $DEBUG;
  ++$something;
  my $new = qq{  "$ENV{NEW}": "$ENV{VALUE}"};
  if (m{"\s*:\s*"}) {
     $keys++;
  }
  if (m{"$ENV{NEW}":})
  {
    $found++;
  };
  if (!$found && m{"$ENV{FIND}":})
  {
    $found++;
    $_ = "$new,\n$_";
  };
  if (m[\A\s*(\{\s*)?\}\s*\z]xms)
  {
    print STDERR "end JSON\n" if $DEBUG;
    my $oneline = m[\A\s*\{\s*\}\s*\z]xms;
    if ($oneline)
    {
      print "{\n";
      $_ = "}\n" 
    }
    if (!$found)
    {
      chomp;
      my $join = $keys ? ",\n" : "";
      $_ = "$join$new\n$_";
    }
    $found = 0;
  }
  END {
    print STDERR "END something: $something keys: $keys found: $found\n" if $DEBUG;
    exit 1 unless $something
  }
' $*
if which prettier > /dev/null; then
	prettier --write $*
fi
