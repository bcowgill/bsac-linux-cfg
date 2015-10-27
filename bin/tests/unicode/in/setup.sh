#!/bin/bash
# set up input data for tests

utf8.pl U+222D > U-222D-TRIPLE-INTEGRAL.utf8.txt

hexdump.exe -C U-222D-TRIPLE-INTEGRAL.utf8.txt
hexdump.exe -f perusal.fmt.txt U-222D-TRIPLE-INTEGRAL.utf8.txt

utf8.pl U+0 U+1 U+2 U+3 U+4 U+5 u+6 u+7 u+8 U+9 u+a u+b u+c u+d u+e u+f u+10 u+11 u+12 u+13 u+14 u+15 u+16 u+17 u+18 u+19 u+20 u+21 u+22 u+23 u+24 u+25> control.utf8.txt

hexdump.exe -C control.utf8.txt
hexdump.exe -f perusal.fmt.txt control.utf8.txt
