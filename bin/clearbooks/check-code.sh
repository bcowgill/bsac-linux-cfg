#!/bin/bash
# check code for common problems

function line
{
	local message
	message="$1"
	perl -e 'print join("\n", ("", "=" x 78, ""))'
	echo "$message"
}

function tsgrep
{
	local pattern
	pattern="$1"
	git grep -E "$pattern" src/ test/
}

function hilite
{
	local pattern
	pattern="$1"
	egrep --color "$pattern"
}

line "no import after const"
tsgrep "\b(import|const)\b" | file-break.pl | hilite '(:|\b(import|const)\b)'

line "use import instead of require"
tsgrep "\b(require)\b" | grep -vE "\b(config-node|bluebird|blocked|jwt-simple)\b" | hilite "\b(require)\b"

line "use export default instead of module.exports"
tsgrep "\b(module\.exports)\b"

line "use const, let instead of let, var where possible"
tsgrep "\b(var|let)\b"

line "use console.error for errors"
tsgrep "console\.log" | hilite "(exception|err(or)?)"

line "use error instead of err"
tsgrep "\b(err|ERR)\b"

line "@param etc frowned upon"
tsgrep "@(param|return)"

line ": any can be fixed?"
tsgrep ":\s*any\b"

exit 1;
git grep -E "\b(import|const)\b" | file-break.pl | grep -v "typings/modules/" | egrep --color '(:|\b(import|const)\b)'

git grep -E "\b(require)\b" | grep -vE "typings/modules/|gulpfile\.js" | grep -vE "\b(config-node|bluebird|blocked|jwt-simple)\b" | egrep --color "\b(require)\b"

git grep -E "\bmodule\.exports\b"
