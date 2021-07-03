#!/bin/bash
OUT=${1:-.}

for file in \
	cp\
	file\
	find\
	grep\
	ln\
	ls\
	mv\
	rm\
	sort\
	tar\
	; do
	man $file > $OUT/$file.txt
done
