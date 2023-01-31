RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0;0m' # No Color

function out {
	echo -e "$*${NC}"
}

function ok {
	out "🆗 ${GREEN}$*"
}

function warning {
	out "${YELLOW}⚠️  $*"
}

function error {
	ERROR=${1:-0}
	out "${RED}❌ ${@:2}"
	#out "${RED}🚩 ${@:2}"
}

function hi {
	local HIGH RESTORE
	RESTORE=${2:-$NC}
	HIGH=${3:-$PURPLE}
	if [ $RESTORE == "ok" ]; then
		RESTORE=$GREEN
	elif [ $RESTORE == "out" ]; then
		RESTORE=$NC
	elif [ $RESTORE == "warn" ]; then
		RESTORE=$YELLOW
	elif [ $RESTORE == "warning" ]; then
		RESTORE=$YELLOW
	elif [ $RESTORE == "error" ]; then
		RESTORE=$RED
	elif [ $RESTORE == "err" ]; then
		RESTORE=$RED
	fi
	if [ $HIGH == "ok" ]; then
		HIGH=$GREEN
	elif [ $HIGH == "out" ]; then
		HIGH=$NC
	elif [ $HIGH == "warn" ]; then
		HIGH=$YELLOW
	elif [ $HIGH == "warning" ]; then
		HIGH=$YELLOW
	elif [ $HIGH == "error" ]; then
		HIGH=$RED
	elif [ $HIGH == "err" ]; then
		HIGH=$RED
	fi
	echo -n "${HIGH}$1${RESTORE}"
}

echo "This is a normal echo message."
out "This is an out message with a [`hi highlight`]."
ok "This is an ok message with [`hi "a highlight" ok`] in color."
warning "This is a warning in [`hi color warning out`]!"
error 12 "This is an error in [`hi color error`]!"
echo "This is a normal echo message."
