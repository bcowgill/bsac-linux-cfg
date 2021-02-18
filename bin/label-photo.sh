#!/bin/bash

FILE="$1"
CAPTION="$2"
COMMENT="${3:-$CAPTION}"
LABEL="${4:-$COMMENT}"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename caption comment label

This will label an image with meta-data for caption, comment and label.

filename The filename for the image or photo to label.
caption  Text for the caption meta-data.
comment  Text for the comment meta-data.  Defaults to the text for caption.
label    Text for the label meta-data. Defaults to the text for comment.
--man    Shows help for this tool.
--help   Shows help for this tool.
-?       Shows help for this tool.

Different image formats support different meta-data so the default is to use the same text for all three values: caption, comment, label.

Example:

$cmd photo.jpg "Caption text" "Comment text" "Label text"
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

if [ -z "$FILE" ]; then
	echo "You must provide an image filename to label."
	usage 1
fi

convert -caption "$CAPTION" \
	-comment "$COMMENT" \
	-label "$LABEL" \
	"$FILE" \
	"$FILE"

identify -format "
%i %G
caption: %[caption]
comment: %[comment]
label:   %[label]
" "$FILE"
