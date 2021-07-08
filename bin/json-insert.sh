#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] find-key new-key [new-value] file...

This will insert a new key/value in a JSON file before the key found.

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
FIND="$FIND" NEW="$NEW" VALUE="$VALUE" perl -i -pne '
  my $new = qq{  "$ENV{NEW}": "$ENV{VALUE}",\n};
  if (m{"$ENV{NEW}":})
  {
    $found++;
  };
  if (!$found && m{"$ENV{FIND}":})
  {
    $found++;
    $_ = "$new$_";
  };
  if (m[\A\s*}\s*\z]xms)
  {
    if (!$found)
    {
      chomp;
      $_ = ",\n$new$_";
    }
    $found = 0;
  }
' $*
