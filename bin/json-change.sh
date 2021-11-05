#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] key [new-value] file...

This will change a key/value in multiple JSON files.

key       The JSON key name to find and change.
new-value optional string value to assign to the new JSON key.  Empty string if omitted. null if the key should be deleted.
file      The JSON files to make changes to.
--man     Shows help for this tool.
--help    Shows help for this tool.
-?        Shows help for this tool.

Assumes the JSON is pretty formatted with a single key value per line.

The key will be looked for as: \"key\":

The new line inserted will be: \"key\": \"new-value\",

If the key isn't found the key will be inserted before the closing }

If the prettier command is on the path then it will be run to clean up the files afterwards.

See also json-plus.pl json-minus.pl json-insert.sh json-common.pl json-translate.pl json-reorder.pl csv2json.sh json_pp json_xs jq

Example:

$cmd paragraph1 \"paragraph-text\" *.json

will change the paragraph1 key value to paragraph-text or add a new paragraph1 key to all the json files.

$cmd paragraph1 *.json

will change the paragraph1 key value to an empty string or add a new empty paragraph1 key to all the json files.

$cmd paragraph1 null *.json

will remove the paragraph1 key and value from all the json files.
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
NEW=$FIND
VALUE="$2"
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

if [ "$VALUE" == "null" ]; then
  echo Will remove key \"$FIND\": in all files specified.
else
  echo Will change or insert key \"$NEW\": \"$VALUE\": in all files specified.
fi
DEBUG=$DEBUG FIND="$FIND" NEW="$NEW" VALUE="$VALUE" perl -i -pne '
  BEGIN { $fileName = $ARGV[0]; }
  my $DEBUG= $ENV{DEBUG};
  ++$something;
  ++$pos;
  print STDERR "$fileName: something: $something keys: $keys found: $found\n" if $DEBUG;
  print STDERR "$pos line: $_" if $DEBUG;
  my $delete = $ENV{VALUE} eq "null";
  my $new = qq{  "$ENV{NEW}": "$ENV{VALUE}"};
  if (m{"\s*:\s*"}) {
     $keys++;
  }
  if (m{"$ENV{NEW}":})
  {
    $found++;
    if ($found > 1)
    {
      print STDERR "$fileName: line $pos: duplicate key found $_";
      exit 2;
    }
    $_ = $delete ? "" : "$new,\n";
    --$keys if $delete;
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
      $_ = $delete ? $_ : "$join$new\n$_";
    }
    $found = 0;
    $pos = 0;
    $fileName = $ARGV[0];
  }
  END {
    print STDERR "END something: $something delete: $delete keys: $keys found: $found\n" if $DEBUG;
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
