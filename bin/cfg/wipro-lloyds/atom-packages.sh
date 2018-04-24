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
#
exit
List of atom package versions on Mac where evaluated

atom -v
Atom    : 1.25.1
Electron: 1.7.11
Chrome  : 58.0.3029.110
Node    : 7.9.0

Built-in Atom Packages (92)
├── atom-dark-syntax@0.29.0
├── atom-dark-ui@0.53.1
├── atom-light-syntax@0.29.0
├── atom-light-ui@0.46.1
├── base16-tomorrow-dark-theme@1.5.0
├── base16-tomorrow-light-theme@1.5.0
├── one-dark-ui@1.10.10
├── one-light-ui@1.10.10
├── one-dark-syntax@1.8.2
├── one-light-syntax@1.8.2
├── solarized-dark-syntax@1.1.4
├── solarized-light-syntax@1.1.4
├── about@1.8.0
├── archive-view@0.64.2
├── autocomplete-atom-api@0.10.7
├── autocomplete-css@0.17.5
├── autocomplete-html@0.8.4
├── autocomplete-plus@2.40.2
├── autocomplete-snippets@1.12.0
├── autoflow@0.29.3
├── autosave@0.24.6
├── background-tips@0.27.1
├── bookmarks@0.45.1
├── bracket-matcher@0.89.1
├── command-palette@0.43.5
├── dalek@0.2.1
├── deprecation-cop@0.56.9
├── dev-live-reload@0.48.1
├── encoding-selector@0.23.8
├── exception-reporting@0.43.1
├── find-and-replace@0.215.5
├── fuzzy-finder@1.7.5
├── github@0.10.3
├── git-diff@1.3.9
├── go-to-line@0.33.0
├── grammar-selector@0.49.9
├── image-view@0.62.4
├── incompatible-packages@0.27.3
├── keybinding-resolver@0.38.1
├── line-ending-selector@0.7.5
├── link@0.31.4
├── markdown-preview@0.159.20
├── metrics@1.2.6
├── notifications@0.70.5
├── open-on-github@1.3.1
├── package-generator@1.3.0
├── settings-view@0.254.1
├── snippets@1.3.1
├── spell-check@0.72.7
├── status-bar@1.8.15
├── styleguide@0.49.10
├── symbols-view@0.118.2
├── tabs@0.109.1
├── timecop@0.36.2
├── tree-view@0.221.3
├── update-package-dependencies@0.13.1
├── welcome@0.36.6
├── whitespace@0.37.5
├── wrap-guide@0.40.3
├── language-c@0.59.2
├── language-clojure@0.22.7
├── language-coffee-script@0.49.3
├── language-csharp@1.0.1
├── language-css@0.42.10
├── language-gfm@0.90.3
├── language-git@0.19.1
├── language-go@0.45.2
├── language-html@0.49.0
├── language-hyperlink@0.16.3
├── language-java@0.28.0
├── language-javascript@0.128.3
├── language-json@0.19.1
├── language-less@0.34.2
├── language-make@0.22.3
├── language-mustache@0.14.5
├── language-objective-c@0.15.1
├── language-perl@0.38.1
├── language-php@0.43.1
├── language-property-list@0.9.1
├── language-python@0.49.2
├── language-ruby@0.71.4
├── language-ruby-on-rails@0.25.3
├── language-sass@0.61.4
├── language-shellscript@0.26.1
├── language-source@0.9.0
├── language-sql@0.25.10
├── language-text@0.7.3
├── language-todo@0.29.4
├── language-toml@0.18.2
├── language-typescript@0.3.2
├── language-xml@0.35.2
└── language-yaml@0.31.2

Community Packages (43) /Users/bcowgill/.atom/packages
├── Sublime-Style-Column-Selection@1.7.4
├── activate-power-mode@2.7.0
├── atom-beautify@0.32.2
├── atom-jest-snippets@2.1.0
├── atom-ternjs@0.18.3
├── atom-transpose@0.3.5
├── atom-wrap-in-tag@0.6.0
├── autoclose-html@0.23.0
├── autocomplete-modules@2.0.0
├── busy-signal@1.4.3
├── case-keep-replace@0.6.1
├── change-case@0.6.5
├── color-picker@2.3.0
├── copy-path@0.5.1
├── docblockr@0.13.7
├── dracula-syntax@2.0.6
├── duplicate-line-or-selection@0.9.0
├── editorconfig@2.2.2
├── emmet@2.4.3
├── emmet-jsx-css-modules@1.0.0
├── es6-javascript@1.0.0
├── file-icons@2.1.18
├── highlight-selected@0.13.1
├── hyperclick@0.1.5
├── intentions@1.1.5
├── js-hyperclick@1.13.0
├── language-babel@2.84.0
├── language-javascript-jsx@0.3.7
├── linter@2.0.0
├── linter-eslint@8.4.1
├── linter-ui-default@1.7.1
├── local-history@4.3.1
├── lodash-snippets@2.0.0
├── pigments@0.40.2
├── prettier-atom@0.53.0
├── project-manager@3.3.5
├── react-es7-snippets@0.3.13
├── related@0.3.5
├── set-syntax@0.4.0
├── sort-lines@0.18.0
├── tab-foldername-index@3.3.0
├── toggle-quotes@1.1.0
└── tree-view-copy-relative-path@1.2.0
