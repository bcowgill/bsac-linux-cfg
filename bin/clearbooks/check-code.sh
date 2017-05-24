#!/bin/bash
# check code for common problems

function line
{
	local message
	message="$1"
	perl -e 'print join("\n", ("", "=" x 78, ""))'
	echo "$message"
}

echo all imports before const
git grep -E "\b(import|const)\b" | file-break.pl | grep -v "typings/modules/" | egrep --color '(:|\b(import|const)\b)'

line "use import instead of require"
git grep -E "\b(require)\b" | grep -vE "typings/modules/|gulpfile\.js" | grep -vE "\b(config-node|bluebird|blocked|jwt-simple)\b" | egrep --color "\b(require)\b"


line "use export default instead of module.exports"
git grep -E "\bmodule\.exports\b"
