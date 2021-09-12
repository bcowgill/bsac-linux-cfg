#!/bin/bash
# Convert a Javascript / React component from index.js/jsx to a named component file and an index.js facade
# MUSTDO finish impolementing this to a general utility

JIRA=PAYO4B-1873

DO=""
#DO="echo"

if [ -z "$JIRA" ]; then
	echo You need to specify a JIRA ticket number
	exit 1
fi

# When component is the default export from index.js or index.jsx
function facade_default {
	local DIR comp INDEX COMP
	DIR="$1"
	comp="$2"

	INDEX="$DIR/index.js"
	INDEX_NEW="$DIR/index.js"
	if [ ! -e "$INDEX" ]; then
		INDEX="$DIR/index.jsx"
	fi
	COMP="$DIR/$comp.jsx"

	if [ -e "$INDEX" ]; then
		if [ ! -e "$COMP" ]; then
			echo git mv "$INDEX" "$COMP"
			$DO git mv "$INDEX" "$COMP"
			$DO git commit --no-verify -m "wip $JIRA create component for facade $COMP"
			echo "export default from './$comp';" to "$INDEX_NEW"
			if [ -z "$DO" ]; then
				echo "export default from './$comp';" > "$INDEX_NEW"
			fi
			echo git add "$INDEX_NEW"
			$DO git add "$INDEX_NEW"
			$DO git commit --no-verify  -m "wip $JIRA create default facade for $COMP"
		else
			echo destination already exists: "$COMP"
		fi
	else
			echo source does not exist: "$INDEX"
	fi
}

# When there are named exports rom index.js or index.jsx
function facade_named {
	local DIR comp INDEX COMP
	DIR="$1"
	comp="$2"

	INDEX="$DIR/index.js"
	INDEX_NEW="$DIR/index.js"
	if [ ! -e "$INDEX" ]; then
		INDEX="$DIR/index.jsx"
	fi
	COMP="$DIR/$comp.jsx"

	if [ -e "$INDEX" ]; then
		if [ ! -e "$COMP" ]; then
			echo git mv "$INDEX" "$COMP"
			$DO git mv "$INDEX" "$COMP"
			$DO git commit --no-verify  -m "wip $JIRA create component for facade $COMP"
			echo "export * from './$comp';" to "$INDEX_NEW"
			if [ -z "$DO" ]; then
				echo "export * from './$comp';" > "$INDEX_NEW"
			fi
			echo git add "$INDEX_NEW"
			$DO git add "$INDEX_NEW"
			$DO git commit --no-verify  -m "wip $JIRA create default facade for $COMP"
		else
			echo destination already exists: "$COMP"
		fi
	else
			echo source does not exist: "$INDEX"
	fi
}

# When component exports both a default and named exports from index.js or index.jsx
function facade_all {
	local DIR comp INDEX COMP
	DIR="$1"
	comp="$2"

	INDEX="$DIR/index.js"
	INDEX_NEW="$DIR/index.js"
	if [ ! -e "$INDEX" ]; then
		INDEX="$DIR/index.jsx"
	fi
	COMP="$DIR/$comp.jsx"

	if [ -e "$INDEX" ]; then
		if [ ! -e "$COMP" ]; then
			echo git mv "$INDEX" "$COMP"
			$DO git mv "$INDEX" "$COMP"
			$DO git commit --no-verify -m "wip $JIRA create component for facade $COMP"
			echo "export * from './$comp';" to "$INDEX_NEW"
			echo "export default from './$comp';" to "$INDEX_NEW"
			if [ -z "$DO" ]; then
				echo "export * from './$comp';" > "$INDEX_NEW"
				echo "export default from './$comp';" >> "$INDEX_NEW"
			fi
			echo git add "$INDEX_NEW"
			$DO git add "$INDEX_NEW"
			$DO git commit --no-verify -m "wip $JIRA create default facade for $COMP"
		else
			echo destination already exists: "$COMP"
		fi
	else
			echo source does not exist: "$INDEX"
	fi
}

# grep export default te detect for _all or _default mode
# grep export \w+ to detect for _all or _named
#facade_all     app/components/views/selection-step selection-step
#facade_default app/components/views/verification-step verification-step
#facade_named    app/components/pattern/selection/accounts-list/recipients-row-account recipients-row-account
#facade_named     app/components/pattern/content/journey-footer journey-footer
#facade_named     app/components/functional/before-unload before-unload
#facade_named     app/components/block/typography/breadcrumb breadcrumb
#facade_named     app/components/pattern/content/contact-link contact-link
