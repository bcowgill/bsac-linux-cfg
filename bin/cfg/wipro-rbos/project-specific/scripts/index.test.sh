#!/bin/bash
# create dummy files to test index.sh

SRC=src
TOPTEST=test
TEST=__test__
SPEC=test

mkdir -p $SRC/img \
	$SRC/components/$TEST \
	$SRC/components/widgets/$TEST \
	$SRC/components/widgets/$TEST/__snapshots__ \
	node_modules \


touch \
	$SRC/setupTests.js \
	$SRC/unknown.txt \
	$SRC/img/404.png \
	$SRC/components/$TEST/ui-test-tools.test.js \
	$SRC/components/$TEST/ui-test-tools.js \
	$SRC/components/widgets/$TEST/listbox.test.js \
	$SRC/components/widgets/$TEST/listbox2.test.js \
	$SRC/components/widgets/$TEST/listbox3.test.js \
	$SRC/components/widgets/$TEST/__snapshots__/listbox.test.js.snap \
	$SRC/components/widgets/listbox.jsx \
	$SRC/components/widgets/dropbox.jsx \
	$SRC/components/widgets/dropbox.test.js \
	$SRC/components/widgets/combobox.jsx \
	$SRC/components/widgets/listbox.css \

echo '// eslint-disable-next-line: max-len' >> $SRC/components/widgets/combobox.jsx
echo 'window.scroll(0)' >> $SRC/components/widgets/combobox.jsx
echo 'documenet.getById()' >> $SRC/components/widgets/combobox.jsx
