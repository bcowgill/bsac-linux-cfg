#!/bin/bash
# perform automated code review based on guidelines at :
# https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

EXPLAIN=${EXPLAIN:-0}

WARNINGS=0

TMP0=`mktemp`
TMP1=`mktemp`
TMP2=`mktemp`
TMP3=`mktemp`
TMP4=`mktemp`

# so that output is filename:match...
GREP="git grep"

# count up some warnings
function warn {
	WARNINGS=$(($WARNINGS + ${1:-1}))
}

# say something to the output file
function say {
	echo "$1" >> $TMP0
}

# display possible heading along with a reason
function give_reason {
	local reason
	reason="$1"

	if [ ! -z "$HEADING" ]; then
		say " $HEADING"
		HEADING=""
	fi
	say "  $reason"
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
		warn $lines
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
	#  $GREP '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	$GREP -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	echo === match non-comments; cat $TMP1
	echo === match regex; cat $TMP2
	indent_output $TMP2 "$reason"
}

# search non-commented shell script lines for something
function search_sh {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain match "$regex"
	$GREP -v '#' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	indent_output $TMP2 "$reason"
}

# search non-commented javascript lines for something
function search_js {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain match "$regex"
	$GREP -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	indent_output $TMP2 "$reason"
}

# search javascript line comments for something
function search_js_comments {
	local regex file reason
	regex="$1"
	file="$2"
	reason="$3"
	explain commented "$regex"
	$GREP '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
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
	$GREP -v '//' "$file" | tee $TMP1 | grep -E "$regex" | tee $TMP2 | grep -vE "$filter" > $TMP3
	indent_output $TMP3 "$reason"
}

# search non-commented javascript lines for something but not something else and show duplicated lines only
function search_js_filter_duplicates {
	local regex filter file reason
	regex="$1"
	filter="$2"
	file="$3"
	reason="$4"
	explain match "$regex except $filter duplicates"
	$GREP -v '//' "$file" | tee $TMP1 | grep -E "$regex" | tee $TMP2 | grep -vE "$filter" | sort | tee $TMP3 | uniq -d > $TMP4
	indent_output $TMP4 "$reason"
}

# search non-commented javascript lines and just report if missing
function has_js {
	local regex file message
	regex="$1"
	file="$2"
	message="$3"

	grep -v '//' "$file" | tee $TMP1 | grep -E "$regex" > $TMP2
	lines=`wc -l < "$TMP2"`
	if [ $lines -lt 1 ]; then
		warn
		if [ -z "$message" ]; then
			give_reason "  missing $regex"
		else
			give_reason "  missing $message"
		fi
	fi
}

# check if a javascript file has the correctly named test plan file
function check_has_test_plan {
	# exports GOT_TEST_PLAN
	local file $SOURCE TEST_PLAN TEST_PLAN2 INDEX CONTAINER REACT
	file="$1"

	if grep -E 'from\s+(.)(react)\1' "$file" > /dev/null; then
		REACT=1
	fi
	# case 4
	TEST_PLAN=`echo "$file" | \
		perl -pne '
			s{\.jsx?\s*\z}{.spec.js}xms;
			s{/([^/]+)\z}{/test/$1}xms
		'`
	if echo "$file" | grep -E "/container\.jsx?\s*$" > /dev/null; then
		# case 6,7,8
		CONTAINER=1
		TEST_PLAN=`echo "$file" | \
			perl -pne '
				s{/([^/]+)/container\.jsx?\s*\z}{/$1/test/$1.container.spec.js}xms
			'`
	fi
	if echo "$file" | grep -E "/index\.jsx?\s*$" > /dev/null; then
		# case 1,2,3
		INDEX=1
		TEST_PLAN=`echo "$file" | \
			perl -pne '
				s{/([^/]+)/index\.jsx?\s*\z}{/$1/test/$1.spec.js}xmsg
			'`
			if [ "$REACT" == "1" ]; then
				SOURCE=`echo "$TEST_PLAN" | \
					perl -pne '
						s{/test/}{/}xms;
						s{\.spec\.jsx?\s*\z}{.jsx}xms;
					'`
				give_reason "react component should be renamed(2): $SOURCE"
			fi
	fi
	if [ ! -f "$TEST_PLAN" ]; then
		if [ -z "$INDEX$CONTAINER" ]; then
			# case 10
			TEST_PLAN2=`echo "$file" | \
				perl -pne '
					s{\.js\s*\z}{.spec.js}xms;
				'`
			if [ ! -f "$TEST_PLAN2" ]; then
				# case 11
				TEST_PLAN2=`echo "$file" | \
					perl -pne '
						s{/([^/]+)\.js\s*\z}{/test/$1.spec.js}xms;
					'`
				if [ ! -f "$TEST_PLAN2" ]; then
					# cases 4,10,11
					give_reason "missing or misnamed test plan, didn't find(4,10,11): $TEST_PLAN or $TEST_PLAN2"
				fi
			fi
		else
			# cases 1,3,8
			give_reason "missing or misnamed test plan, didn't find(1,3,8): $TEST_PLAN"
		fi
	fi
	if [ -f "$TEST_PLAN" ]; then
		GOT_TEST_PLAN="$TEST_PLAN"
	fi
	if [ -f "$TEST_PLAN2" ]; then
		GOT_TEST_PLAN="$TEST_PLAN2"
	fi
}

# check if a javascript test plan has been named to match a source file
# 1 path-name/index.js                => test/path-name.spec.js
# 2 path-name/index.jsx               => rename path-name/path-name.jsx
# 3 path-name/index.jsx               => test/path-name.spec.js
# 4 path-name/path-name.jsx           => test/path-name.spec.js
# 5 path-name/path-name.js            => rename path-name/path-name.jsx
# 6 path-name/container.js            => rename path-name/path-name.container.js
# 7 path-name/container.jsx           => rename path-name/path-name.container.js
# 8 path-name/path-name.container.js  => test/path-name.container.spec.js
# 9 path-name/test/container.spec.js  => rename path-name/test/path-name.container.spec.js
# 10 path-name/util.js                => path-name/util.spec.js
# or
# 11 path-name/util.js                => test/util.spec.js
# 12 path-name/index.js               => rename path-name/path-name.js
# 13 path-name/any.spec.jsx           => rename path-name/any.spec.js
# 14 path-name/test/any.spec.jsx      => rename path-name/test/any.spec.js
function check_test_plan_target {
	local file INDEX _NAME SOURCE_NAME INDEX CONTAINER REACT
	file="$1"

	if echo "$file" | grep -E '\.jsx$' > /dev/null; then
		# case 13,14
		give_reason "test plan is named incorrectly, should NOT have .jsx extension (13,14)"
	fi
	if grep -E 'from\s+(.)(react|enzyme|react-testing-library)\1' "$file" > /dev/null; then
		REACT=1
	fi
	if echo $file | grep 'container.spec' > /dev/null; then
		# case 6,7,8,9
		CONTAINER=1
		INDEX_NAME=`echo "$file" | \
			perl -pne '
				s{/test/}{/}xmsg;
				s{\.container\.spec}{}xmsg;
				s{/[^/]+\z}{/container.js}xmsg;
			'`
		SOURCE_NAME=`echo "$file" | \
			perl -pne '
				s{/test/}{/}xmsg;
				s{\.spec}{}xmsg;
			'`
		if [ ! -f "$SOURCE_NAME" ]; then
			if [ -f "$INDEX_NAME" ]; then
				# case 6
				# not required right now to rename container files
				true
				# give_reason "testing target: $INDEX_NAME should be renamed(6): $SOURCE_NAME"
			else
				if [ -f "${INDEX_NAME}x" ]; then
					# case 7
					give_reason "testing target: ${INDEX_NAME}x should be renamed(7): $SOURCE_NAME"
				else
					# case 8,9
					give_reason "test plan may be named incorrectly didn't find testing target(8,9): $SOURCE_NAME"
				fi
			fi
		fi
	else
		INDEX_NAME=`echo "$file" | \
			perl -pne '
				s{/test/}{/}xmsg;
				s{\.spec}{}xmsg;
				s{/[^/]+\z}{/index.js}xmsg;
			'`
		SOURCE_NAME=`echo "$file" | \
			perl -pne '
				s{/test/}{/}xmsg;
				s{\.spec}{}xmsg;
				s{(\.js)x?\z}{$1}xmsg;
			'`
		if [ "$REACT" == 1 ]; then
			if [ -f "$SOURCE_NAME" ]; then
				# case 5
				give_reason "testing target: $SOURCE_NAME should be renamed(5): ${SOURCE_NAME}x"
			else
				if [ ! -f "${SOURCE_NAME}x" ]; then
					if [ -f "$INDEX_NAME" ]; then
						# case 1
						give_reason "testing target: $INDEX_NAME should be renamed(1): ${SOURCE_NAME}x"
					else
						if [ -f "${INDEX_NAME}x" ]; then
							# case 2,3
							give_reason "testing target: ${INDEX_NAME}x should be renamed(2,3): ${SOURCE_NAME}x"
						else
							# case 4
							give_reason "test plan may be named incorrectly didn't find testing target(4): ${SOURCE_NAME}x"
						fi
					fi
				fi
			fi
		else
			if [ ! -f "$SOURCE_NAME" ]; then
				if [ -f "$INDEX_NAME" ]; then
					# case 12
					give_reason "testing target: $INDEX_NAME should be renamed(12): $SOURCE_NAME"
				else
					# case 10,11
					give_reason "test plan may be named incorrectly didn't find testing target(10,11): $SOURCE_NAME"
				fi
			fi
		fi
	fi
}

# perform the code review showing problems
function code_review {
	local file code_review_ok
	file="$1"

	echo $file:
	WARNINGS=0
	WARNINGS_EXPECTED=0
	GOT_TEST_PLAN=
	echo -n > $TMP0
	if [ -e "$file" ]; then
		code_review_ok=`grep -E '//\s+code-review-ok:' "$file" | head -1 | perl -pne 's{\A.*:\s*(\d+).*\z}{$1}xms'`
		WARNINGS_EXPECTED=${code_review_ok:-0}

	# EXPLAIN=1
	# HEADING="DEBUGGING..."
	# search_debug 'case\b[^:]+?:[^\{]*$' "$file"      "should have {} around all case X: statements"
	# exit 1

	HEADING="checking for incomplete work..."
	search_js 'MUS''TDO' "$file"  "work which MUST be completed asap"
	search_js 'MMM|NNN' "$file"  "function of variables which need to be named properly"
	search_js_comments 'MUS''TDO' "$file"  "work which MUST be completed asap"
	search_js 'TO''DO' "$file"  "work which needs to be done"
	search_js_comments 'TO''DO' "$file"  "work which might need doing"

	if grep -E 'describe\(' "$file" > /dev/null; then
		HEADING="checking for bad test plan practices..."
		check_test_plan_target "$file"
		has_js 'eslint-disable prefer-arrow-callback' "$file" "test plan MUST have /* eslint-disable prefer-arrow-callback */"
		has_js 'const\s+suite\b' "$file" "test plan MUST define suite name"
		has_js "'$file'" "$file" "test plan MUST have const suite = '$file';"
		# TODO beforeEach/afterEach anon functions
		search_js '\b[fx](it|describe)\s*\(' "$file"  "MUST restore describe/it test"
		search_js '\b(it|describe)\.(only|skip)\s*\(' "$file"  "MUST restore describe/it test"
		search_js_comments '[fx]?(it|describe)\s*\(' "$file"  "MUST use skip feature instead of commenting out tests"
		search_js_comments '(it|describe)\.(only|skip)\s*\(' "$file"  "MUST use skip feature instead of commenting out tests"
		search_js '\.called' "$file" "MUST use .callCount instead of .called or .calledOnce (code-fix)"
		search_js 'toBe(True|Truthy|False|Falsy|Null|Undefined|Defined)' "$file" "MUST use expectTruthy() etc functions with numbered labels (code-fix)"
		search_js 'to(Be|Equal)\((true|false|null|undefined)' "$file" "MUST use expectTruthy() etc functions with numbered labels (code-fix)"
		search_js '\)\.toEqual\(\s*[\{\[]' "$file" "use expectObjectsDeepEqual/expectArraysDeepEqual where possible to validate objects or arrays"
		search_js 'expect\(.+\.args.+\)\s*$' "$file" "use expectObjectsDeepEqual/expectArraysDeepEqual where possible to validate spy call parameters"
		search_js 'expect\(.+\.args.+?\)\.to(Be|Equal)\(\s*([^`'\''"0-9]|$)' "$file" "use expectObjectsDeepEqual/expectArraysDeepEqual where possible to validate spy call parameters"

		search_js '\.toEqual\(' "$file" "use .toBe() except when comparing objects/NaN/jasmine.any"
		# TODO spy.callCount missing before checking spy calls
		# TODO expect() .toBe/Equal
		search_js '\b(describe)\b.+\(\)\s*=>\s*\{$' "$file"  "MUST name your describe function something like descObjectNameSuite instead of using anonymous function (code-fix)"
		search_js '\b(describe)\b.+\bfunction\s+(test|desc[a-z])' "$file"  "MUST name your describe function something like descObjectNameSubSuite"
		search_js '\b(it|skip\w+)\b.+\(\s*\w*\s*\)\s*=>\s*\{$' "$file"  "should name your it function something like testObjectNameFunctionMode instead of using anonymous function (code-fix)"
		search_js '\b(it|skip\w+)\b.+\bfunction\s+(desc|test[a-z])' "$file"  "MUST name your it function something like testObjectNameFunctionMode"
		search_js '\b(beforeEach|afterEach)\(\s*\w*\s*\)\s*=>\s*\{$' "$file"  "should name your before/afterEach function something like setupTestsMode or tearDownMode instead of using anonymous function (code-fix)"
		# TODO       it('should reject promise on server error', (done) => {
	else
		# Not a test plan...
		if echo "$file" | grep -E '\.jsx?\s*$' | grep -vE '(mock|stub|story)\.js' > /dev/null; then
			check_has_test_plan "$file"
		fi
		HEADING="checking for app specific idioms..."
		search_js_filter 'function\s+(\w+(Action|Service|Middleware))\s*\(' EOB "$file"  "Actions etc should use it = EOB calling protocol"
		search_js_filter 'const\s+(\w+(Action|Service|Middleware))\s*=\s*\(' EOB "$file" "Actions etc should use it = EOB calling protocol"
		search_js_filter_duplicates '\(pageInfo\)' 'mockAPI' "$file" "MUST fix duplicated cypress mock-api routes"
	fi

	HEADING="checking for code to remove..."
	search_js '\bdebugger\b' "$file" "MUST remove leftover debugger breakpoints"
	search_js '\balert\(' "$file"    "MUST remove browser alert messages"

	HEADING="checking for practices to minimise..."
	# excludes test plan spy console.error.restore();
	search_js_filter '\bconsole\.\w+' 'console\.\w+\.restore\(\)' "$file"   "MUST remove leftover console debug logs"
	search_js '\bNODE_ENV\b' "$file"  "reduce code blocks dependent on release environment"

	HEADING="checking for unnecessary obfuscation..."
	search_js '`\$\{\w+\}`' "$file" "pointless use of template string \`\${quotes}\` or use .toString()"

	HEADING="checking for bad style..."
	search_js '(#|&#[xX]|0x|\\u)[A-Fa-f0-9]*[A-F][A-Fa-f0-9]*' "$file" "hex (color) MUST use lower case for easier reading"
	search_js '&#(\d+|[xX][a-fA-F0-9]+);' "$file" "MUST define a const character name instead of encoding a character"
	search_js '=>[^\{]*$' "$file"                 "should have { return ... } on all arrow functions"
	search_js 'case\b[^:]+?:[^\{]*$' "$file"      "should have {} around all case X: statements"
	search_js 'default\s*:[^\{]*$' "$file"        "should have {} around all switch default: statements"
	search_js '([A-Z_]+)\s*:\s*(.)\1\2' "$file"   "MUST use list.reduce for defining Action constants"

	if grep -E 'from\s+(.)react\1' "$file" > /dev/null; then
		if grep -E 'describe\(' "$file" > /dev/null; then
			# a test plan with react in it
			true
		else
			if echo "$file" | grep 'story.js' > /dev/null; then
				HEADING="checking for React storybook issues..."
			else
				HEADING="checking for React issues..."
				has_js 'displayName' "$file" "MUST define displayName"
				has_js 'propTypes' "$file" "MUST define propTypes"
				has_js 'defaultProps' "$file" "MUST define defaultProps"
				search_js '<[a-z]+[A-Z]' "$file" "MUST not name components starting with lower case or it will render as an HTML element not a component"
				search_js '\s+on\w+\s*\(' "$file" "MUST not bind events in constructor, define event with arrow function instead"
				search_js '(this.\w+)\s*=\s*\1\.bind' "$file" "MUST not bind events in constructor, define event with arrow function instead"
				search_js '=\{\s*\([^)]*\)\s*=>' "$file"  "MUST not use anonymous event handlers in render"
				search_js 'src=[^\{]' "$file"  "MUST not use paths to assets, import them into a constant for webpack optimisation"
			fi
		fi
	fi
	if grep -E 'connect.+from\s+(.)react-redux\1' "$file" > /dev/null; then
		HEADING="checking for Redux container issues..."
	fi

	if echo "$file" | grep -E '\.(less|sass|css)$'; then
		HEADING="checking for bad stylesheet practices..."
		search_js '\[data-selector=' "$file" "MUST use class instead of data- attributes for styling"
	fi

	if grep -E '^\s*Feature:' "$file" > /dev/null; then
		HEADING="checking for bad Gherkin style..."
		search_sh '@(skip|only)' "$file"              "MUST remove @skip or @only marker"
		search_sh ':\s+Feature:' "$file"              "incorrect Feature: indentation (MUST be zero) (code-fix)"
		search_sh ':(\s?|\s{3,})@devCWA' "$file"      "incorrect @devCWA: indentation (MUST be two spaces) (code-fix)"
		search_sh ':(\s?|\s{3,})@skip' "$file"        "incorrect @skip: indentation (MUST be two spaces) (code-fix)"
		search_sh ':(\s?|\s{3,})Scenario:' "$file"    "incorrect Scenario: indentation (MUST be two spaces) (code-fix)"
		search_sh ':(\s?|\s{3,})Background:' "$file"  "incorrect Background: indentation (MUST be two spaces) (code-fix)"
		search_sh ':(\s{0,3}|\s{5,})Given' "$file"    "incorrect Given step indentation (MUST be four spaces) (code-fix)"
		search_sh ':(\s{0,3}|\s{5,})When' "$file"     "incorrect When step indentation (MUST be four spaces) (code-fix)"
		search_sh ':(\s{0,3}|\s{5,})Then' "$file"     "incorrect Then step indentation (MUST be four spaces) (code-fix)"
		search_sh ':(\s{0,5}|\s{7,})And' "$file"      "incorrect And step indentation (MUST be six spaces) (code-fix)"
	fi

	# TODO alt,aria-label= without copyText
	else
		echo "File not found!"
	fi
	if [ $(($WARNINGS - $WARNINGS_EXPECTED)) != 0 ]; then
		if [ 0 == $WARNINGS_EXPECTED ]; then
			echo " $WARNINGS code review warnings."
		else
			echo " $WARNINGS code review warnings, $WARNINGS_EXPECTED declared by code-review-ok:"
		fi
		cat $TMP0
	fi
# TODO run the test plan and/or code review it
	if [ ! -z "$GOT_TEST_PLAN" ]; then
		echo " has test plan:"
		code_review "$GOT_TEST_PLAN"
	fi
} # code_review

if [ -z "$1" ]; then
	echo "
usage: $0 filename...

Perform automated code review based on guidelines at:

https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

Output showing MUST are hard rules to be implemented.

Output showing (code-fix) can be automatically or semi-automatically fixed by the code-fix.sh script.

To review all the files on your branch:

$0 \`git diff --name-only develop\`
"
	exit 1
fi

for file in $*
do
	if echo "$file" | grep -vE 'code-(review|fix)\.sh' > /dev/null; then
		code_review "$file"
	fi
done

rm $TMP0 $TMP1 $TMP2 $TMP3 $TMP4
