#!/bin/bash
# WINDEV tool useful on windows development machine
CONTENT=
export CONTENT_FILE=$1
shift
if [ "--content" == "$CONTENT_FILE" ]; then
	CONTENT="$1"
	shift
	export CONTENT_FILE=`mktemp`
	echo "$CONTENT" >> $CONTENT_FILE
fi

if [ -z "$1" ]; then
	cat <<EOF
usage: $(basename $0) [--content "content to prepend"] [content-filename] file ...

This script will insert some content at the top of the files listed.

--content  specify the actual content to insert into the files.
content-filename  specifies the file to insert into the files.

See also middle.sh, inject-middle.sh

example:

$(basename $0) --content "/* eslint max-len: 100 */" filename
EOF
	exit 1
fi

#echo "CONTENT=$CONTENT"
#echo "CONTENT_FILE=$CONTENT_FILE"
#cat "$CONTENT_FILE"
#echo args $*

perl -e '
	BEGIN
	{
		local $/ = undef;
		my $fh;
		open($fh, "<", $ENV{CONTENT_FILE}) || die "content file <$ENV{CONTENT_FILE}>: $!";
		$content = <$fh>;
		close($fh);
	}

	foreach my $file (@ARGV)
	{
		local $/ = undef;
		print "inserting content into $file\n";
		my $fh;
		open($fh, "<", $file) || die "target file <$file>: $!";
		my $target = <$fh>;
		close($fh);

		open($fh, ">", $file) || die "target file <$file>: $!";
		print $fh $content . $target;
		close($fh);
	}
' $*

if [ ! -z "$CONTENT" ]; then
	rm "$CONTENT_FILE"
fi

