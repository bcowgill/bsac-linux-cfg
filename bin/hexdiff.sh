#!/bin/bash
HEX="hexdump -C"
hexdump -e '32/1 "%02X ""\t"" "' -e '32/1 "%_u ""\n"'    "$1" > "$1.hex"
hexdump -e '32/1 "%02X ""\t"" "' -e '32/1 "%_u ""\n"'    "$2" > "$2.hex"
vdiff.sh "$1.hex" "$2.hex"
