#!/bin/bash
# Install atom packages for JS/React
# https://medium.com/productivity-freak/my-atom-editor-setup-for-js-react-9726cd69ad20
apm install \
	editorconfig \
	atom-beautify \
	prettier-atom \
	file-icons \
	language-javascript-jsx \
	language-babel \
	highlight-selected \
	duplicate-line-or-selection \
	sort-lines \
	set-syntax \
	tab-foldername-index \
	change-case \
	case-keep-replace \
	tree-view-copy-relative-path \
	copy-path \
	sublime-style-column-selection \
	autocomplete-modules \
	local-history \
	atom-wrap-in-tag \
	atom-ternjs \
	autoclose-html \
	pigments \
	color-picker \
	docblockr \
	es6-javascript \
	js-hyperclick \
	hyperclick \
	emmet \
	emmet-jsx-css-modules \
	linter-eslint \
	linter \
	linter-ui-defaults \
	intentions \
	react-es7-snippets \
	atom-jest-snippets \
	lodash-snippets \
	dracula-theme \
	project-manager \

#               toggle-quotes \ # not working
#               related \ # not working
#               atom-transpose \ # not working
#               sync-settings \  # requires access to Github gist

# Beautify Ctrl-Alt-b
# Prettier Ctrl-Alt-f
# Keep Case Replace Ctrl-Cmd-r
# Change Case (Camel/Snake) Cmd-k Cmd-c  or Cmd-s
# Copy Path Editor Tab->Right Click->Copy Path
# Duplicate Line/Selection Cmd-Shift-d
# Highlight Selected Word->Double Click
# Set Syntax Cmd-Shift-p ssjs  for example to set to javascript
# Sort Lines F5
# Sort Lines Cmd-Shift-p sort  for other sort orders
# Alt-MouseDrag  to block select text
# Intelligence Ctrl-Alt-Shift-d  jump to definition of symbol
# Intelligence Ctrl-Alt-c  rename symbol aware of scope
# Intelligence Ctrl-Shift-r  show symbol references
# Intelligence Ctrl-Alt-Space  begin symbol completion
# Intelligence Alt-o  show documentation for symbol
# Intelligence Cmd-Ctrl-Shift-Left/Right  navigate left/right
# Wrap Tag Alt-Shift-w  wrap word/selection in HTML tag
# Color Picker Cmd-Shift-c
# Doc Blockr  //* Tab  creates @doc comment block
# Emmet Ctrl-Alt-j  jump to matching element pair
# Emmet Cmd-Shift-p emm  to see other emmet commands
# ES6 ima Tab   expand to import * as
# ES6 imn Tab   expand to import { name } from
# Hyperclick Cmd-LeftClick  jump to symbol definition
# Hyperclick Cmd-MouseMove  underlines clickable text under cursor
# Copy Relative Path  Project View->RightClick->Copy Relative Path




# Had troubles getting these to work:
# Toggle Quotes Cmd-Shift-'  toggle between single/double quoted strings
# Related Ctrl-Shift-r open related file .spec.js .js etc
# Related Cmd-Shift-p Related Edit  to edit the regex for related files
# '^(.*[/\\\\])?(.+)(\\.js|\\.jsx)$': [
#    '**/$2.spec.js',
#    '**/$2.css'
#]
# Javascript test or style files
#'([^\\/]+)(?!\\.spec).js(x?)$': [
#  '$1.spec.js$2#create',
#]
#'(.+).spec.js(x?)$': [
#  '$1.js$2',
#]

# Project Manager Cmd-Ctrl-p to List Projects
# Project Manager Cmd-Shift-p Project Save to save current session as a project

# Transpose Alt-t or Ctrl-Shift-t
