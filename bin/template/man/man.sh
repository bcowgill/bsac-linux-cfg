#!/bin/bash
OUT=${1:-.}

for file in \
	awk \
	bash \
	cp \
	diff \
	file \
	find \
	grep \
	head \
	hexdump \
	ln \
	ls \
	mv \
	perl \
	rm \
	sed \
	shred \
	sort \
	strings \
	tail \
	tar \
	test \
	tr \
	uniq \
	xargs \
	; do
	echo [$file]
	if [ ! -z "$file" ]; then
		man $file > $OUT/$file.txt
	fi
done
