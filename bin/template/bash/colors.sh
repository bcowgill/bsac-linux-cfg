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

function hi {
  local RESTORE
  RESTORE=${2:-$NC}
  echo -n "${PURPLE}$1${RESTORE}"
}

function warning {
  out "${YELLOW}⚠️  $*"
}

function error {
    ERROR=${1:-0}
    out "${RED}❌ ${@:2}"
}


echo "This is a normal echo message."
out "This is an out  message with a [`hi highlight`]."
ok "This is an ok message with [`hi "a highlight" $GREEN`] in color."
warning "This is a warning in [`hi color $YELLOW`]!"
error 12 "This is an error in [`hi color $RED`]!"
echo "This is a normal echo message."
