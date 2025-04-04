#!/bin/bash
# alarm-if.sh ./check-deployed.sh ~/bin/sounds/that_was_easy.wav
# quick tool to check if something deployed by looking at the version file for a ticket number
TIX=${1:-2022-11-08}
TIX=${1:-DIP-3099}
URL=${2:-https://www.digitalhealthxtra.hk.medi24.com/version.txt}
URL=${2:-https://dev.emma2lite.demo.access-to-care-medi24.com/version.txt}
URL=${2:-https://dev.emma2.demo.access-to-care-medi24.com/version.txt}
curl $URL | head | grep $TIX
