#!/bin/bash

function get {
	local url file
	url=$1
	file=`basename $url`
	wget -O $file "$url"
}

# ace jump mode
get https://raw.githubusercontent.com/winterTTr/ace-jump-mode/master/ace-jump-mode.el

# editorconf file handling
get https://raw.githubusercontent.com/editorconfig/editorconfig-emacs/master/editorconfig.el
get https://raw.githubusercontent.com/editorconfig/editorconfig-emacs/master/editorconfig-core.el
get https://raw.githubusercontent.com/editorconfig/editorconfig-emacs/master/editorconfig-core-handle.el
get https://raw.githubusercontent.com/editorconfig/editorconfig-emacs/master/editorconfig-fnmatch.el

# log key strokes in an emacs buffer
# http://foldr.org/~michaelw/emacs/
get http://www.foldr.org/~michaelw/emacs/mwe-log-commands.el

# readline completion for emacs shell
get https://github.com/monsanto/readline-complete.el/raw/master/readline-complete.el
