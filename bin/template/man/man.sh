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
	echo [$file]
	if [ ! -z "$file" ]; then
		man $file > $OUT/$file.txt
	fi
done
