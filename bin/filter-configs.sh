#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?] [-v] [path...]

This will filter a list of file names looking for common configuration file names and extensions.

-v      Filter out the config files and show all other files.
--regex Shows the regex used for matching config file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.


See also egrep filter-code-files.sh filter-scripts.sh filter-text.sh, filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-videos.sh, filter-web.sh, filter-css.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/cfg

Example:

locate -i pipeline | $cmd
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ "$1" == "--regex" ]; then
	GREP="echo"
fi

$GREP '(robots\.txt|(pre(pare)?|post)-(commit(-msg)?|push|rebase|applypatch|auto-gc|receive|update|checkout|rewrite|merge)|package(-lock)?\.json|(mix|deno|yarn|composer|flake)\.lock|env\.\w+|(Make|Gem|Rake|Docker)file|\w\w\w+rc|\.(cfg|ini|reg|profile|bash_\w+|(x|ya?)ml)|conf|config|env(\.\w+)?|properties(.ru)?|htaccess|editorconfig|vtg|vp([wj]|whistu)|cson|iml|jinja2?|j2|jinger|git(attributes|modules)|(git|npm|jshint|eslint|stylelint|prettier|docker)ignore|(bower|csslint|jshint|vim|npm|nvm)rc|jshintrc-\w+)(:|"|\s*$)' $* # .xml .yml .yaml pre-commit pre-push Makefile Gemfile Rakefile .gitattributes .gitmodules .gitignore .npmignore .jshintignore .eslintignore .stylelintignore .prettierignore .bowerrc .csslintrc .jshintrc .vimrc Dockerfile .dockerignore .nvmrc .npmrc .env env.local .env.local .lock package.json package-lock.json mix.lock deno.lock yarn.lock composer.lock flake.lock .profile

# OS specific files...
#.DS_Store