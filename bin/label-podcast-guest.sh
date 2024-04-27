TRACK=$1
GUEST="$2"
FILE="$3"
PREFIX="Agile for Humans"

if [ -z "$FILE" ]; then
	echo "
$0 track \"guest\" filename

	You must provide a track number and guest name as well as file name.
	The title prefix is coded to be: "$PREFIX"
"

	exit 1
fi

TITLE="$PREFIX $TRACK $GUEST"

id3v2 --song "$TITLE" \
	--TIT2 "$TITLE" \
	--track $TRACK \
	"$FILE"

id3v2 --list "$FILE"

