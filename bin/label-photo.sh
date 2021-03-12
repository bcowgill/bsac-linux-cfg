#!/bin/bash

FILE="$1"
COMMENT="$2"
LABEL="${3:-$COMMENT}"
CAPTION="${4:-$LABEL}"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename [comment] [label] [caption]

This will label an image with meta-data for comment, label and caption.

filename The filename for the image or photo to label.
comment  Text for the comment meta-data.
label    Text for the label meta-data. Defaults to the text for comment.
caption  Text for the caption meta-data.  Defaults to the text for label.
--man    Shows help for this tool.
--help   Shows help for this tool.
-?       Shows help for this tool.

Different image formats support different meta-data so the default is to use the same text for all three values: caption, comment, label if only one is specified.

If caption, comment and label are omitted it will show the current values for the image specified.

Example:

$cmd photo.jpg "Comment text" "Label text" "Caption text"
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

if [ ! -z "$CAPTION" ]; then
	convert -caption "$CAPTION" \
		-comment "$COMMENT" \
		-label "$LABEL" \
		"$FILE" \
		"$FILE"
fi

identify -format "
%i %G
comment: %[comment]
label:   %[label]
caption: %[caption]
" "$FILE"
