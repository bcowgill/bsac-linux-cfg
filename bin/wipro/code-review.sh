#!/bin/bash
# perform automated code review based on guidelines at :
# https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

EXPLAIN=${EXPLAIN:-0}

TMP1=`mktemp`
TMP2=`mktemp`
TMP3=`mktemp`

# display possible heading along with a reason
function give_reason {
	local reason
	reason="$1"

	if [ ! -z "$HEADING" ]; then
		echo " $HEADING"
		HEADING=""
	fi
	echo "  $reason"
}

# if EXPLAIN display possible heading and what the regex match is for
function explain {
	local what regex
	what="$1"
	regex="$2"
	if [ "$EXPLAIN" == "1" ]; then
		give_reason "$what $regex"
	fi
}

# display possible heading and indented match output if any
function indent_output {
	local file reason lines
	file="$1"
	reason="$2"

	lines=`wc -l < "$file"`
	if [ $lines -gt 0 ]; then
		give_reason "$reason"
		perl -pne 's{\A.+?:\s*}{      }xmsg' "$file"
	fi
}

# for debugging why a match didn't work
function search_debug {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain match "$regex"
	git grep -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	echo === match1; cat $TMP1
	echo === match2; cat $TMP2
	indent_output $TMP2 "$reason"
}

# search non-commented shell script lines for something
function search_sh {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain match "$regex"
	git grep -v '#' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	indent_output $TMP2 "$reason"
}

# search non-commented javascript lines for something
function search_js {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain match "$regex"
	git grep -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	indent_output $TMP2 "$reason"
}

# search javascript line comments for something
function search_js_comments {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain commented "$regex"
	git grep '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	indent_output $TMP2 "$reason"
}

# search non-commented javascript lines for something but not something else
function search_js_filter {
	local regex filter file reason
	regex="$1"
	filter="$2"
	file="$3"
	reason="$4"
	explain match "$regex except $filter"
	git grep -v '//' "$file" | tee $TMP1 | grep -E "$regex" | tee $TMP2 | grep -v "$filter" > $TMP3
	indent_output $TMP3 "$reason"
}

# search non-commented javascript lines and just report if missing
function has_js {
	local regex file message
	regex="$1"
	file="$2"
	message="$3"

	git grep -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	lines=`wc -l < "$TMP2"`
	if [ $lines -lt 1 ]; then
		if [ -z "$message" ]; then
			give_reason "  missing $regex"
		else
			give_reason "  missing $message"
		fi
	fi
}

# check if a javascript file has the correctly named test plan file
function check_has_test_plan {
	local file
	file="$1"

	TEST_PLAN=`echo "$file" | perl -pne 's{\.js}{.spec.js}xmsg; s{/([^/]+)\z}{/test/$1}xmsg'`
	if echo "$file" | grep -E "/container\.jsx?$" > /dev/null; then
		TEST_PLAN=`echo "$file" | perl -pne 's{/([^/]+)/container\.js(x)?}{/$1/test/$1.container.spec.js$2}xmsg'`
	fi
	if echo "$file" | grep -E "/index\.jsx?$" > /dev/null; then
		TEST_PLAN=`echo "$file" | perl -pne 's{/([^/]+)/index\.js(x)?}{/$1/test/$1.spec.js$2}xmsg'`
	fi
	if [ ! -f "$TEST_PLAN" ]; then
		give_reason "missing or misnamed test plan, didn't find: $TEST_PLAN"
	fi
}

# check if a javascript test plan has been named to match a source file
function check_test_plan_target {
	local file
	file="$1"

	if echo $file | grep 'container.spec' > /dev/null; then
		INDEX_NAME=`echo "$file" | perl -pne 's{/test/}{/}xmsg; s{\.container\.spec}{}xmsg; s{/[^/]+\z}{/container.js}xmsg;'`
		SOURCE_NAME=`echo "$file" | perl -pne 's{/test/}{/}xmsg; s{\.spec}{}xmsg;'`
		if [ ! -f "$SOURCE_NAME" ]; then
			if [ -f "$INDEX_NAME" ]; then
				give_reason "testing target: $INDEX_NAME should be renamed: $SOURCE_NAME"
			else
				give_reason "test plan may be named incorrectly didn't find testing target: $SOURCE_NAME"
			fi
		fi
	else
		INDEX_NAME=`echo "$file" | perl -pne 's{/test/}{/}xmsg; s{\.spec}{}xmsg; s{/[^/]+\z}{/index.js}xmsg;'`
		SOURCE_NAME=`echo "$file" | perl -pne 's{/test/}{/}xmsg; s{\.spec}{}xmsg;'`
		if [ ! -f "$SOURCE_NAME" ]; then
			if [ -f "$INDEX_NAME" ]; then
				give_reason "testing target: $INDEX_NAME should be renamed: $SOURCE_NAME"
			else
				if [ -f "${INDEX_NAME}x" ]; then
					give_reason "testing target: ${INDEX_NAME}x should be renamed: ${SOURCE_NAME}x"
				else
					give_reason "test plan may be named incorrectly didn't find testing target: $SOURCE_NAME"
				fi
			fi
		fi
	fi
}

# perform the code review showing problems
function code_review {
	local file
	file="$1"

	echo $file:
	if git grep -E 'describe\(' "$file" > /dev/null; then
		HEADING="checking for bad test plan practices..."
		check_test_plan_target "$file"
		has_js 'eslint-disable prefer-arrow-callback' "$file" "test plan should have /* eslint-disable prefer-arrow-callback */"
		has_js 'const\s+suite\b' "$file" "test plan should define suite name"
		has_js "'$file'" "$file" "const suite = '$file';"
		search_js '[fx](it|describe)\s*\(' "$file"  "restore describe/it test"
		search_js '(it|describe)\.(only|skip)\s*\(' "$file"  "restore describe/it test"
		search_js_comments '[fx]?(it|describe)\s*\(' "$file"  "use skip feature instead of commenting out tests"
		search_js_comments '(it|describe)\.(only|skip)\s*\(' "$file"  "use skip feature instead of commenting out tests"
		search_js '\.called' "$file" "use .callCount instead of .called or .calledOnce"
		search_js 'expect\(.+\.args' "$file" "use expectObjectsDeepEqual/expectArraysDeepEqual where possible to validate spy call parameters"

		# search expect\((\w+)(.+)\)\.toBe\(true\)
		# replace expectTrue('$1NNN', $1$2)
		search_js 'toBe(True|Truthy|False|Falsy|Null|Undefined|Defined)' "$file" "use expectTruthy() etc functions with numbered labels"
		search_js 'to(Be|Equal)\((true|false|null|undefined)' "$file" "use expectTruthy() etc functions with numbered labels"
		search_js '\.toEqual\(' "$file" "use .toBe() except when comparing objects/NaN/jasming.any"
		# TODO spy.callCount missing before checking spy calls
		# TODO expect() .toBe/Equal
		search_js '(describe|it).+\(\)\s*=>\s*\{$' "$file"  "should name your describe/it function as descXxxSuite/testXxx instead of using anonymous"
	else
		if echo "$file" | grep -E '\.jsx?$' | grep -vE '(mock|stub|story)\.js' > /dev/null; then
			check_has_test_plan "$file"
		fi
	fi

	HEADING="checking for incomplete work..."
	search_js 'MUS''TDO' "$file"  "work which must be completed asap"
	search_js_comments 'MUS''TDO' "$file"  "work which must be completed asap"
	search_js 'TO''DO' "$file"  "work which needs to be done"
	search_js_comments 'TO''DO' "$file"  "work which might need doing"

	HEADING="checking for code to remove..."
	search_js '\bdebugger\b' "$file" "remove leftover debugger breakpoints"
	search_js '\balert\(' "$file"    "remove browser alert messages"

	HEADING="checking for practices to minimise..."
	search_js '\bconsole\.' "$file"   "remove leftover console debug logs"
	search_js '\bNODE_ENV\b' "$file"  "reduce code blocks dependent on release environment"

	HEADING="checking for unnecessary obfuscation..."
	search_js '`\$\{\w+\}`' "$file" "pointless use of template string \`\${quotes}\`"

	HEADING="checking for bad style..."
	search_js '(#|&#[xX]|0x|\\u)[A-Fa-f0-9]*[A-F][A-Fa-f0-9]*' "$file" "hex (color) should use lower case for easier reading"
	search_js '&#(\d+|[xX][a-fA-F0-9]+);' "$file" "should define a const character name instead of encoding a character"
	search_js '=>[^\{]*$' "$file"                 "should have { return ... } on all arrow functions"
	search_js 'case\b[^:]+?:[^\{]*$' "$file"      "should have {} around all case X: statements"
	search_js 'default\s*:[^\{]*$' "$file"        "should have {} around all switch default: statements"
	search_js '([A-Z_]+)\s*:\s*(.)\1\2' "$file"   "should use list.reduce for defining Action constants"

	if git grep -E 'from\s+(.)react\1' "$file" > /dev/null; then
		if git grep -E 'describe\(' "$file" > /dev/null; then
			# a test plan with react in it
			true
		else
			if echo "$file" | grep 'story.js' > /dev/null; then
				HEADING="checking for React storybook issues..."
			else
				HEADING="checking for React issues..."
				has_js 'displayName' "$file" "should define displayName"
				has_js 'propTypes' "$file" "should define propTypes"
				has_js 'defaultProps' "$file" "should define defaultProps"
				search_js '\s+on\w+\s*\(' "$file" "dont bind events in constructor, define event with arrow function instead"
				search_js '(this.\w+)\s*=\s*\1\.bind' "$file" "dont bind events in constructor, define event with arrow function instead"
				search_js '=\{\s*\([^)]*\)\s*=>' "$file"  "dont use anonymous event handlers in render"
				search_js 'src=[^\{]' "$file"  "dont use paths to assets, import them into a constant for webpack optimisation"
			fi
		fi
	fi
	if git grep -E 'connect.+from\s+(.)react-redux\1' "$file" > /dev/null; then
		HEADING="checking for Redux container issues..."
	fi

	if echo "$file" | grep -E '\.(less|sass|css)$'; then
		HEADING="checking for bad stylesheet practices..."
		search_js '\[data-selector=' "$file" "use class instead of data- attributes for styling"
	fi

	if grep -E '^\s*Feature:' "$file" > /dev/null; then
		HEADING="checking for bad Gherkin style..."
		search_sh '@(skip|only)' "$file"              "remove @skip or @only marker"
		search_sh ':\s+Feature:' "$file"              "incorrect Feature: indentation (should be zero)"
		search_sh ':(\s?|\s{3,})@devCWA' "$file"      "incorrect @devCWA: indentation (should be two spaces)"
		search_sh ':(\s?|\s{3,})@skip' "$file"        "incorrect @skip: indentation (should be two spaces)"
		search_sh ':(\s?|\s{3,})Scenario:' "$file"    "incorrect Scenario: indentation (should be two spaces)"
		search_sh ':(\s?|\s{3,})Background:' "$file"  "incorrect Background: indentation (should be two spaces)"
		search_sh ':(\s{0,3}|\s{5,})Given' "$file"    "incorrect Given step indentation (should be four spaces)"
		search_sh ':(\s{0,3}|\s{5,})When' "$file"     "incorrect When step indentation (should be four spaces)"
		search_sh ':(\s{0,3}|\s{5,})Then' "$file"     "incorrect Then step indentation (should be four spaces)"
		search_sh ':(\s{0,5}|\s{7,})And' "$file"      "incorrect And step indentation (should be six spaces)"
	fi

	HEADING="checking for app specific idioms..."
	search_js_filter 'function\s+(\w+(Action|Service|Middleware))\s*\(' EOB "$file"  "Actions etc should use it = EOB calling protocol"
	search_js_filter 'const\s+(\w+(Action|Service|Middleware))\s*=\s*\(' EOB "$file" "Actions etc should use it = EOB calling protocol"

	# TODO alt,aria-label= without copyText
}

for file in $*
do
	code_review "$file"
done


rm $TMP1 $TMP2 $TMP3
