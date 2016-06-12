#!/usr/bin/env perl
# display an emacs key reference or substitute emacs key commands into
# a user supplied text file

# convert the cursor motion keys from the emacsercises to ergoemacs letter motion keys
# perl -e 'local $/ = undef; $_ = <>; sub trr { my $s = shift; $s =~ tr[bfpn][jlik]; return $s; }; s{(\s* [bfpn] \b (\s+[bfpn]\b)?\s*\%)}{trr($1)}xmsge; s{(START \s+ ->.+2 \s+ =====)}{ trr($1) }xmsge; print $_'  emacsercises.markup.txt

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use autodie qw(open);

our $VERSION = 0.1;
our $DEBUG = 1;

our $SHORTEN_KEYS = 0;
our $USE_META = 0;
our $HIDE_UNKNOWN = 1;
our $OUT_HTML = 1;

our $rhSub;

sub out {
	my ($html) = @ARG;
	unless ($OUT_HTML) {
		$html =~ s{<i>}{ }xmsg;
		$html =~ s{</?(kbd|code|i)>}{}xmsg;
	}
	return $html;
}

# key combination/chord
sub k {
	my $combo = join(" ", map { "<kbd>$ARG</kbd>" } @ARG);
	if ($USE_META) {
		$combo =~ s{Alt-}{Meta-}xmsg;
	}
	return short($combo);
}

sub short {
	my ($combo) = @ARG;
	if ($SHORTEN_KEYS) {
		$combo =~ s{Ctrl-}{C-}xmsg;
		$combo =~ s{Shift-}{S-}xmsg;
		$combo =~ s{Meta-}{M-}xmsg;
		$combo =~ s{Alt-}{A-}xmsg;
		$combo =~ s{Menu-}{m-}xmsg; # lower case m for menu
	}
	return $combo;
}

# variable key combination like Alt-N for Alt-0, Alt-1, ...
sub kk {
	my ($prefix, $param) = @ARG;
	return "<kbd>@{[short($prefix)]}<i>$param</i></kbd>"
}

# execute-extended-command line function
sub fn {
	my ($function) = @ARG;
	return short($rhSub->{'execute-extended-command'})
		. " <code>$function</code>";
}

# key combination with parameter
sub p {
	my ($combo, $param) = @ARG;
	return k($combo) . "  <i>$param</i>";
}

#===========================================================================
sub initKeyMap {
	my ($mode) = @ARG;
	return $mode eq 'emacs' ? initEmacsKeyMap() : initErgoKeyMap();
}

sub initEmacsKeyMap {
my $rhSubEmacs = {
	''                                 => '',
	'[MODE]'                           => 'Emacs',

	'space'                            => k('Space'),

	# Exit
	'suspend-frame'                    => k('Ctrl-z'),
	'save-buffers-kill-terminal'       => k('Ctrl-x', 'Ctrl-c'),

	# Params / Prefix keys
	'-character-extend'                => k('Ctrl-x'),
	'execute-extended-command'         => k('Alt-x'),
	'-prefix-key'                      => k('Ctrl-u'),
	'universal-argument'               => p('Ctrl-u', 'number/-number'),
	'-universal-argument0'             => k('Ctrl-u', '0'),
	'-universal-argument1'             => k('Ctrl-u', '1'),
	'-universal-argument2'             => k('Ctrl-u', '2'),
	'-universal-argument3'             => k('Ctrl-u', '3'),
	'-universal-argument4'             => k('Ctrl-u', '4'),
	'-universal-argument5'             => k('Ctrl-u', '5'),
	'-universal-argument6'             => k('Ctrl-u', '6'),
	'-universal-argument7'             => k('Ctrl-u', '7'),
	'-universal-argument8'             => k('Ctrl-u', '8'),
	'-universal-argument9'             => k('Ctrl-u', '9'),
	'digit-argument'                   => kk('Alt-', 'N'),
	'negative-argument'                => k('Alt--'),
	'-neg-arg1'                        => k('Ctrl--'),
	'-neg-arg2'                        => k('Ctrl-Alt--'),
	'quoted-insert'                    => p('Ctrl-q', 'char'),

	# Error Recovery
	'keyboard-quit'                    => k('Ctrl-g'),
	'keyboard-escape-quit'             => k('Esc', 'Esc', 'Esc'),
	'recover-session'                  => \&fn,
	'undo'                             => k('Ctrl-/'),
	'-undo2'                           => k('Ctrl-_'),
	'-undo1'                           => k('Ctrl-x', 'u'),
	'undo-tree-redo'                   => k('Ctrl-u', 'Ctrl-/'),
	'-undo-tree-redo1'                 => k('Ctrl-u', 'Ctrl-_'),
	'revert-buffer'                    => \&fn,
	'redraw-display'                   => \&fn,
	'widen'                            => k('Ctrl-x', 'n', 'w'),
	'narrow-to-region'                 => k('Ctrl-x', 'n', 'n'),

	# Movement Compass rose
	'backward-page'                    => k('Ctrl-x', '['),
	'backward-paragraph'               => k('Alt-{'),
	'backward-sentence'                => k('Alt-a'),
	'move-beginning-of-line'           => k('Ctrl-a'),
	'backward-word'                    => k('Alt-b'),
	'backward-char'                    => k('Ctrl-b'),
	'recenter-top-bottom'              => k('Ctrl-l'),
	'forward-char'                     => k('Ctrl-f'),
	'forward-word'                     => k('Alt-f'),
	'move-end-of-line'                 => k('Ctrl-e'),
	'forward-sentence'                 => k('Alt-e'),
	'forward-paragraph'                => k('Alt-}'),
	'forward-page'                     => k('Ctrl-x', ']'),
	'beginning-of-buffer'              => k('Alt-<'),
	'scroll-down-command'              => k('Alt-v'),
	'previous-line'                    => k('Ctrl-p'),
	'next-line'                        => k('Ctrl-n'),
	'scroll-up-command'                => k('Ctrl-v'),
	'end-of-buffer'                    => k('Alt->'),
	'scroll-left'                      => k('Ctrl-x', '<'),
	'scroll-right'                     => k('Ctrl-x', '>'),

	# Motion
	'goto-line'                        => k('Alt-g') . p('g', 'number'),
	'goto-char'                        => k('Alt-g') . p('c', 'number'),
	'back-to-indentation'              => k('Alt-m'),
	'backwards-sexp'                   => k('Ctrl-Alt-b'),
	'forwards-sexp'                    => k('Ctrl-Alt-f'),
	'ace-jump-mode'                    => k('Ctrl-c') . p('Space', 'first letter of word'),
	'ace-jump-line-mode'               => k('Ctrl-u', 'Ctrl-u', 'Ctrl-c', 'Space'),
	'-ace-jump-mode2'                  => k('Ctrl-u', 'Ctrl-c') . p('Space', 'letter to go to'),
	'ace-jump-mode-pop-mark'           => k('Ctrl-c', q{C-Space}),

	# Mark / Select
	'set-mark-command'                 => k('Ctrl-Space'),
	'-set-mark-command1'               => k('Ctrl-@'),
	'exchange-point-and-mark'          => k('Ctrl-x', 'Ctrl-x'),
	'mark-word'                        => k('Alt-@'),
	'-mark-to-start-of-word'           => k('Alt--', 'Alt-@'),
	'mark-paragraph'                   => k('Alt-h'),
	'mark-page'                        => k('Ctrl-x', 'Ctrl-p'),
	'mark-sexp'                        => k('Ctrl-Alt-@'),
	'mark-function'                    => k('Ctrl-Alt-h'),
	'mark-whole-buffer'                => k('Ctrl-x', 'h'),

	# Delete / Cut
	'delete-backward-char'             => k('Backspace'),
	'backward-delete-char-untabify'    => k('Backspace'),
	'delete-forward-char'              => k('Delete'),
	'delete-char'                      => k('Ctrl-d'),
	'backward-kill-word'               => k('Ctrl-Backspace'),
	'-backward-kill-word0'             => k('Alt-Delete'),
	'-backward-kill-word1'             => k('Alt-Backspace'),
	'kill-word'                        => k('Alt-d'),
	'kill-line'                        => k('Ctrl-k'), # delete to end of line
	'-kill-to-start-of-line'           => k('Alt-0', 'Ctrl-k'), # zero arg, kill-line
	'kill-sentence'                    => k('Alt-k'),
	'backward-kill-sentence'           => k('Ctrl-x', 'Backspace'),
	'-kill-backwards-sexp'             => k('Alt--', 'Ctrl-Alt-k'), # negative arg, kill-sexp
	'kill-sexp'                        => k('Ctrl-Alt-k'),
	'kill-region'                      => k('Ctrl-w'),
	'kill-ring-save'                   => k('Alt-w'),
	'yank'                             => k('Ctrl-y'),
	'yank-pop'                         => k('Alt-y'),
	'zap-to-char'                      => p('Alt-z', 'char'),

	# Files and Buffers
	'find-file'                        => k('Ctrl-x', 'Ctrl-f'),
	'save-buffer'                      => k('Ctrl-x', 'Ctrl-s'),
	'save-some-buffers'                => k('Ctrl-x', 's'),
	'insert-file'                      => k('Ctrl-x', 'i'),
	'find-alternate-file'              => k('Ctrl-x', 'Ctrl-v'),
	'write-file'                       => k('Ctrl-x', 'Ctrl-w'),
	'read-only-mode'                   => k('Ctrl-x', 'Ctrl-q'),

	# Help
	'-help1'                           => k('Ctrl-h'),
	'-help2'                           => k('F1'),
	'help-for-help'                    => k('Ctrl-h', '?'),
	'help-with-tutorial'               => k('Ctrl-h', 't'),
	'delete-other-windows'             => k('Ctrl-x', '1'),
	'scroll-other-window'              => k('Ctrl-Alt-v'),
	'apropos-command'                  => k('Ctrl-h','a'),
	'describe-key-briefly'             => k('Ctrl-h', 'c'),
	'describe-key'                     => k('Ctrl-h', 'k'),
	'describe-variable'                => k('Ctrl-h', 'v'),
	'describe-function'                => k('Ctrl-h', 'f'),
	'describe-mode'                    => k('Ctrl-h', 'm'),
	'info'                             => k('Ctrl-h', 'i'),
	'info-emacs-manual'                => k('Ctrl-h', 'r'),

	# Incremental Search
	'isearch-forward'                  => k('Ctrl-s'),
	'isearch-backward'                 => k('Ctrl-r'),
	'isearch-forward-regexp'           => k('Ctrl-Alt-s'),
	'isearch-backward-regexp'          => k('Ctrl-Alt-r'),
	'-previous-search-string'          => k('Alt-p'),
	'-next-search-string'              => k('Alt-n'),
	'-exit-isearch'                    => k('Enter'),
	'-backspace-isearch'               => k('Backspace'),

	# Search and Replace
	'query-replace'                    => k('Alt-%'),
	'query-replace-regexp'             => k('Ctrl-Alt-%'),
	'-replace'                         => k('Space'),
	'-replace1'                        => k('y'),
	'-replace-skip'                    => k('Backspace'),
	'-replace-skip1'                   => k('n'),
	'-replace-stay'                    => k(','),
	'-replace-all'                     => k('!'),
	'-replace-help'                    => k('Ctrl-h'),
	'-replace-back'                    => k('^'),
	'-replace-exit'                    => k('Enter'),
	'-replace-newline'                 => k('Ctrl-q', 'Ctrl-j'),
	'-replace-custom'                  => k('Ctrl-r'),
	'-replace-custom-exit'             => k('Ctrl-Alt-c'),

	# Multiple Windows
	'delete-other-windows'             => k('Ctrl-x', 1),
	'delete-other-frames'              => k('Ctrl-x', 5, 1),
	'split-window-below'               => k('Ctrl-x', 2),
	'make-frame-command'               => k('Ctrl-x', 5, 2),
	'delete-window'                    => k('Ctrl-x', 0),
	'delete-frame'                     => k('Ctrl-x', 5, 0),
	'split-window-right'               => k('Ctrl-x', 3),
	'scroll-other-window'              => k('Ctrl-Alt-v'),
	'other-window'                     => k('Ctrl-x', 'o'),
	'other-frame'                      => k('Ctrl-x', 5, 'o'),
	'switch-to-buffer-other-window'    => k('Ctrl-x', 4, 'b'),
	'switch-to-buffer-other-frame'     => k('Ctrl-x', 5, 'b'),
	'display-buffer'                   => k('Ctrl-x', 4, 'Ctrl-o'),
	'display-buffer-other-frame'       => k('Ctrl-x', 5, 'Ctrl-o'),
	'find-file-other-window'           => k('Ctrl-x', 4, 'f'),
	'-find-file-other-window1'         => k('Ctrl-x', 4, 'Ctrl-f'),
	'find-file-other-frame'            => k('Ctrl-x', 5, 'f'),
	'find-file-read-only-other-window' => k('Ctrl-x', 4, 'r'),
	'find-file-read-only-other-frame'  => k('Ctrl-x', 5, 'r'),
	'dired-other-window'               => k('Ctrl-x', 4, 'd'),
	'dired-other-frame'                => k('Ctrl-x', 5, 'd'),
	'find-tag-other-window'            => k('Ctrl-x', 4, '.'),
	'find-tag-other-frame'             => k('Ctrl-x', 5, '.'),
	'enlarge-window'                   => k('Ctrl-x', '^'),
	'shrink-window-horizontally'       => k('Ctrl-x', '{'),
	'enlarge-window-horizontally'      => k('Ctrl-x', '}'),

	# Formatting
	'indent-for-tab-command'           => k('Tab'),
	'indent-region'                    => k('Ctrl-Alt-\\'),
	'indent-sexp'                      => k('Ctrl-Alt-q'),
	'indent-rigidly'                   => k('Ctrl-x', 'Tab'),
	'comment-dwim'                      => k('Alt-;'),
	'open-line'                        => k('Ctrl-o'),
	'split-line'                       => k('Ctrl-Alt-o'),
	'delete-blank-lines'               => k('Ctrl-x', 'Ctrl-o'),
	'delete-indentation'               => k('Alt-^'),
	'delete-horizontal-space'          => k('Alt-\\'),
	'just-one-space'                   => k('Alt-Space'),
	'fill-paragraph'                   => k('Alt-q'),
	'set-fill-column'                  => k('Ctrl-x', 'f'),
	'set-fill-prefix'                  => k('Ctrl-x', '.'),
	'set-face'                         => k('Alt-o'),

	# Case Change
	'upcase-word'                      => k('Alt-u'),
	'downcase-word'                    => k('Alt-l'),
	'capitalize-word'                  => k('Alt-c'),
	'upcase-region'                    => k('Ctrl-x', 'Ctrl-u'),
	'downcase-region'                  => k('Ctrl-x', 'Ctrl-l'),
	# The Minibuffer
	'minibuffer-complete'              => k('Tab'),
	'minibuffer-complete-word'         => k('Space'),
	'minibuffer-complete-and-exit'     => k('Enter'),
	'minibuffer-completion-help'       => k('?'),
	'-minibuffer-previous'             => k('Alt-p'),
	'-minibuffer-next'                 => k('Alt-n'),
	'-minibuffer-history-isearch-reverse' => k('Alt-r'),
	'minibuffer-history-isearch-search'   => k('Alt-s'),
	'minibuffer-keyboard-quit'            => k('Ctrl-g'),
	'menu-bar-open'                       => k('F10'),
	'repeat-complex-command'              => k('Ctrl-x', 'Esc', 'Esc'),

	# Buffers
	'switch-to-buffer'                    => k('Ctrl-x', 'b'),
	'list-buffers'                        => k('Ctrl-x', 'Ctrl-b'),
	'kill-buffer'                         => k('Ctrl-x', 'k'),

	# Transposing
	'transpose-chars'                     => k('Ctrl-t'),
	'transpose-words'                     => k('Alt-t'),
	'transpose-lines'                     => k('Ctrl-x', 'Ctrl-t'),
	'transpose-sexps'                     => k('Ctrl-Alt-t'),

	# Spelling Check
	'ispell-word'                         => k('Alt-$'),
	'ispell-region'                       => \&fn,
	'ispell-buffer'                       => \&fn,
	'flyspell-mode'                       => \&fn,

	# Tags
	'find-tag'                            => k('Alt-.'),
	'pop-tag-mark'                        => k('Alt-'),
	'-find-next-tag'                      => k('Ctrl-u', 'Alt-.'),
	'-find-prev-tag'                      => k('Alt--', 'Alt-.'),
	'visit-tags-table'                    => \&fn,
	'tags-search'                         => \&fn,
	'tags-query-replace'                  => \&fn,
	'tags-loop-continue'                  => k('Alt-,'),

	# Shells
	'shell-command'                       => k('Alt-!'),
	'async-shell-command'                 => k('Alt-&'),
	'shell-command-on-region'             => k('Alt-pipe'),
	'-shell-command-on-region1'           => k('Ctrl-u', 'Alt-pipe'),
	'shell'                               => \&fn,

	# Rectangles
	'copy-rectangle-to-register'          => k('Ctrl-x', 'r') . p('r', 'character'),
	'-delete-rectangle-to-register'       => k('Ctrl-u', 'Ctrl-x', 'r') . p('r', 'character'),
	'insert-register'                     => k('Ctrl-x', 'r') . p('g', 'character'),
	'kill-rectangle'                      => k('Ctrl-x', 'r', 'k'),
	'delete-rectangle'                    => k('Ctrl-x', 'r', 'd'),
	'yank-rectangle'                      => k('Ctrl-x', 'r', 'y'),
	'open-rectangle'                      => k('Ctrl-x', 'r', 'o'),
	'clear-rectangle'                     => k('Ctrl-x', 'r', 'c'),
	'string-rectangle'                    => k('Ctrl-x', 'r', 't'),
	'string-insert-rectangle'             => \&fn,
	'rectangle-number-lines'              => k('Ctrl-x', 'r', 'N'),
	'delete-whitespace-rectangle'         => \&fn,
	'rectangle-mark-mode'                 => k('Ctrl-x', 'Space'),

	# Abbrevs
	'abbrev-mode'                         => \&fn,
	'edit-abbrevs'                        => \&fn,
	'list-abbrevs'                        => \&fn,
	'unexpand-abbrev'                     => \&fn,
	'write-abbrev-file'                   => \&fn,
	'abbrev-prefix-mark'                  => k("Alt-'"),
	'add-global-abbrev'                   => k('Ctrl-x', 'a', 'g'),
	'add-mode-abbrev'                     => k('Ctrl-x', 'a', 'l'),
	'-add-mode-abbrev1'                   => k('Ctrl-x', 'a', '+'),
	'-add-mode-abbrev2'                   => k('Ctrl-x', 'a', 'Ctrl-a'),
	'inverse-add-global-abbrev'           => k('Ctrl-x', 'a', 'i', 'g'),
	'-inverse-add-global-abbrev1'         => k('Ctrl-x', 'a', '-'),
	'inverse-add-mode-abbrev'             => k('Ctrl-x', 'a', 'i', 'l'),
	'expand-abbrev'                       => k('Ctrl-x', 'a', 'e'),
	'-expand-abbrev1'                     => k('Ctrl-x', "'"),
	'-expand-abbrev2'                     => k('Ctrl-x', 'a', "'"),
	'dabbrev-expand'                      => k('Alt-/'),
	'dabbrev-completion'                  => k('Ctrl-Alt-/'),
	'-dabbrev-completion16'               => k('Ctrl-u', 'Ctrl-u', 'Ctrl-Alt-/'),

	# International Character Sets
	'set-language-environment'            => k('Ctrl-x', 'Enter', 'l'),
	'list-input-methods'                  => \&fn,
	'toggle-input-method'                 => k('Ctrl-\\'),
	'universal-coding-system-argument'    => k('Ctrl-x', 'Enter', 'c'),
	'list-coding-systems'                 => \&fn,
	'prefer-coding-system'                => \&fn,

	# Register
	'copy-to-register'                    => k('Ctrl-x', 'r') . p('s', 'character'),
	'-copy-to-register2'                  => k('Ctrl-x', 'r') . p('x', 'character'),
	'-delete-to-register'                 => k('Ctrl-u', 'Ctrl-x', 'r') . p('s', 'character'),
	'-delete-to-register2'                => k('Ctrl-u', 'Ctrl-x', 'r') . p('x', 'character'),
	'insert-register'                     => k('Ctrl-x', 'r') . p('i', 'character'),
	'-insert-register2'                   => k('Ctrl-x', 'r') . p('g', 'character'),
	'-insert-register-move'               => k('Ctrl-u', 'Ctrl-x', 'r') . p('i', 'character'),
	'-insert-register-move2'              => k('Ctrl-u', 'Ctrl-x', 'r') . p('g', 'character'),
	'point-to-register'                   => k('Ctrl-x', 'r') . p('Space', 'character'),
	'-point-to-register0'                 => k('Ctrl-x', 'r', 'Space', 0),
	'-point-to-register2'                 => k('Ctrl-x', 'r') . p('Ctrl-Space', 'character'),
	'-point-to-register3'                 => k('Ctrl-x', 'r') . p('Ctrl-@', 'character'),
	'-frame-arrangement-to-register'      => k('Ctrl-u', 'Ctrl-x', 'r') . p('Space', 'character'),
	'jump-to-register'                    => k('Ctrl-x', 'r') . p('j', 'character'),
	'-jump-to-register0'                  => k('Ctrl-x', 'r', 'j', 0),
	'-frame-arrangement-from-register'    => k('Ctrl-u', 'Ctrl-x', 'r') . p('j', 'character'),

	# Keyboard Macros
        'kmacro-start-macro-or-insert-counter' => k('F3'),
        'kmacro-end-or-call-macro'             => k('F4'),
	'-last-kmacro-forever'                 => k('Ctrl-u', '0', 'Ctrl-x', ')'),
	'-last-kmacro-forever2'                => k('Ctrl-u', '0', 'F4'),
        'kmacro-start-macro'                   => k('Ctrl-x', '('),
        'kmacro-end-macro'                     => k('Ctrl-x', ')'),
        'kmacro-end-and-call-macro'            => k('Ctrl-x', 'e'),
        '-kmacro-append-to-last-macro'         => k('Ctrl-u', 'Ctrl-x', '('),
        'name-last-kbd-macro'                  => \&fn,
        'insert-kbd-macro'                     => \&fn,

	# HEREIAM
	# Miscellaneous
	# Regular Expressions
	# Info
	# Commads Dealing with Emacs Lisp
	# Simple Customisation
	# Writing Commands
};
return $rhSubEmacs;
}

#===========================================================================
sub initErgoKeyMap {
my $rhSubErgo = {
	''                                 => '',
	'[MODE]'                           => 'Ergoemacs',
	'space'                            => k('Space'),

	# Exit
	'suspend-frame'                    => 'undefined',
	'save-buffers-kill-terminal'       => k('Ctrl-x', 'Ctrl-c'),

	# Params / Prefix keys
	'execute-extended-command'         => k('Alt-a'),
	'universal-argument'               => p('Ctrl-u', 'number/-number'),
	'-universal-argument4'             => k('Ctrl-u', '4'),
	'digit-argument'                   => kk('Ctrl-Alt-', 'N'),
	'negative-argument'                => k('Ctrl-Alt--'),
	'-neg-arg1'                        => 'undefined',
	'-neg-arg2'                        => 'undefined',
	'quoted-insert'                    => p('Ctrl-q', 'char'),

	# Error Recovery
	'keyboard-quit'                    => k('Ctrl-g'),
	'keyboard-escape-quit'             => k('Esc', 'Esc', 'Esc'),
	'recover-session'                  => \&fn,
	'undo'                             => k('Ctrl-z'),
	'-undo1'                           => k('Alt-z'),
	'undo-tree-redo'                   => k('Ctrl-Shift-z'),
	'-undo-tree-redo1'                 => k('Alt-Shift-z'),
	'revert-buffer'                    => k('Ctrl-r'),
	'redraw-display'                   => \&fn,

	# Movement Compass rose
	'backward-page'                    => k('Alt-Shift-i'),
	'backward-paragraph'               => k('Alt-Shift-u'),
#	'backward-sentence'                => 'undefined',
	'move-beginning-of-line'           => k('Alt-h'),
	'backward-word'                    => k('Alt-u'),
	'backward-char'                    => k('Alt-j'),
	'recenter-top-bottom'              => k('Alt-p'),
	'forward-char'                     => k('Alt-l'),
	'forward-word'                     => k('Alt-o'),
	'move-end-of-line'                 => k('Alt-Shift-h'),
#	'forward-sentence'                 => 'undefined',
	'forward-paragraph'                => k('Alt-Shift-o'),
	'forward-page'                     => k('Alt-Shift-k'),
	'beginning-of-buffer'              => k('Alt-n'),
#	'scroll-down-command'              => 'undefined',
	'previous-line'                    => k('Alt-i'),
	'next-line'                        => k('Alt-k'),
#	'scroll-up-command'                => 'undefined',
	'end-of-buffer'                    => k('Alt-Shift-n'),
#	'scroll-left'                      => 'undefined',
#	'scroll-right'                     => 'undefined',

	# Motion
	'goto-line'                        => k('Ctrl-l'),
#	'goto-char'                        => k('Alt-g', 'c'),
	'back-to-indentation'              => k('Alt-m'),
	'ergoemacs-backward-open-bracket'  => k('Shift-Alt-j'),
	'ergoemacs-forward-close-bracket'  => k('Shift-Alt-l'),
	'backwards-sexp'                   => k('Ctrl-Alt-b'),
	'forwards-sexp'                    => k('Ctrl-Alt-f'),

	# HEREIAM

};
return $rhSubErgo;
}

#===========================================================================
my $map = 'emacs';

if (scalar(@ARGV)) {
	if ($ARGV[0] =~ m{\Aergo\z}xmsi) {
		$map = 'ergo';
		shift @ARGV;
	}
}

if (scalar(@ARGV)) {
	my $fh;

	$SHORTEN_KEYS = 1;
	$OUT_HTML = 0;
	$HIDE_UNKNOWN = 0;
	$USE_META = 0;

	$rhSub = initKeyMap($map);

	open($fh, '<', $ARGV[0]);
	while (my $line = <$fh>) {
		transformLine($line);
	}
}
else {
	$rhSub = initKeyMap($map);
	while (my $line = <DATA>) {
		transformLine($line);
	}
}

sub transformLine {
	my ($line) = @ARG;

	my $hasKey = 0;
	$line =~ s{
		\%([^\%]*)\%
		}{
		$hasKey = 1 unless substr($1, 0, 1) eq '[';
		if ($rhSub->{$1}) {
			if (ref($rhSub->{$1})) {
				out($rhSub->{$1}->($1));
			}
			else {
				out($rhSub->{$1});
			}
		}
		else {
			if ($HIDE_UNKNOWN) {
				'undefined'
			}
			else {
				out(fn($1))
			}
		}
	}xmsge;

	# shorthand table header/cell
	if ($line =~ m{ \A \s* th \| }xms) {
		$line =~ s{\|}{</th><th>}xmsg;
		$line =~ s{ \A \s* th</th> }{<tr>}xms;
		$line =~ s{ (</th>)<th> \s*? (\n|\z)}{$1</tr>$2}xms;
	}
	$line =~ s{ \A \s* \| }{<tr><td>}xms;
	$line =~ s{ \| \s*? (\n|\z)}{</td></tr>$1}xms;
	$line =~ s{\|}{</td><td>}xmsg;

	$line =~ s{or\s+undefined}{}xmsg;
	$line =~ s{undefined}{}xmsg;

	$line =~ s{-pipe}{-|}xmsg;

	if ($HIDE_UNKNOWN && $hasKey && $line !~ m{<kbd>}xms) {
		$line = '';
	}

	print "$line";
}

#===========================================================================
# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

sub warning
{
	my ($warning) = @ARG;
	warn( "WARN: " . tab($warning) . "\n" );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	print tab($msg) . "\n" if ( $DEBUG >= $level );
}

sub usage
{
	my ($msg) = @ARG;
	print "$msg\n\n" if $msg;
	print <<"USAGE";
usage: $0

TODO short usage
USAGE
	exit($msg ? 1: 0);
}

#===========================================================================
__DATA__
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>%[MODE]% Key Binding Reference</title>

<style>
th,td {
	padding: 4px;
}
.right {
	text-align: right;
}
.left {
	text-align: left;
}
th,td,.mid {
	text-align: center;
}
table.compass td {
	border: 1px solid #ccc;
	empty-cells: hide;
}
table.define th,table.define td {
	text-align: left;
}
div.box kbd {
	opacity: 1;
	padding-bottom: 1px;
	color: #777;
	background-color: #fbfbfb;
	border-color: #d5d5d5;
	box-shadow: 0 1px 0 0 #c8c8c8;
}
kbd {
	white-space: nowrap;
	font-family: inherit;
	font-weight: normal;
	font-style: normal;
	padding: 1px 4px;
	background-color: white;
	border: solid 1px #d9d9d9;
	border-radius: 3px;
	color: #777;
	box-shadow: 0 1px 0 0 #ccc;
}
</style>

</head>
<body>
<div class="box">

<h1>%[MODE]% Key Binding Reference</h1>

<h2>Leaving Emacs</h2>

<table class="define">
|%suspend-frame%|suspend Emacs (or iconify it under X)|
|%save-buffers-kill-terminal%|exit Emacs ask to save|
</table>

<h2>Error Recovery</h2>

<table class="define">
|%keyboard-quit%|abort a partially typed or executing command|
|%keyboard-escape-quit%|all purpose get out. recursive edit mode, windows, minibuffer...|
|%recover-session%|recover files lost by a system crash|
|%undo% or %-undo1% or %-undo2%|undo an unwanted change|
|%undo-tree-redo% or %-undo-tree-redo1%|redo previous undo|
|%revert-buffer%|revert a buffer to what is in the disk file|
|%widen%|widen the scope of the editor to show the entire buffer|
|%redraw-display%|redraw screen|
</table>

<h2>Modifier Keys</h2>

<table class="define">
|%execute-extended-command% <i>function-name</i>|Executes a named command function|
|%universal-argument%|Specify a +/- numeric argument for the next command|
|%digit-argument%|Specify a numeric argument for the next command|
|%negative-argument% or %-neg-arg1% or %-neg-arg2%|Begin a negative argument for the next command|
|%quoted-insert%|Insert the next character literally|
</table>

<h2>Compass rose for moving around the buffer.</h2>

<table class="compass">
th||sentence|home|word|column||column|word|end|sentence|
<th class="right">document</th><td>||||%beginning-of-buffer%|||||
	<th class="right">page</th><td>||||%backward-page%|||||
  <th class="right">screen</th><td>||||%scroll-down-command%|||||
	<th class="right">paragraph</th><td>||||%backward-paragraph%|||||
	<th class="right">line</th><td>||||%previous-line%|||||
		<th class="right"></th><td>%backward-sentence%|%move-beginning-of-line%|%backward-word%|%backward-char%|%recenter-top-bottom%|%forward-char%|%forward-word%|%move-end-of-line%|%forward-sentence%|
	<th class="right">line</th><td>||||%next-line%|||||
	<th class="right">paragraph</th><td>||||%forward-paragraph%|||||
  <th class="right">screen</th><td>||||%scroll-up-command%|||||
	<th class="right">page</th><td>||||%forward-page%|||||
<th class="right">document</th><td>||||%end-of-buffer%|||||
th||sentence|home|word|column||column|word|end|sentence|
</table>

<h2>Other Motion</h2>

<table class="define">
|%recenter-top-bottom%|scroll current line to center, top or bottom in succession|
|%scroll-left%|scroll view to left|
|%scroll-right%|scroll view to right|
|%ergoemacs-backward-open-bracket%|backwards to first open bracket|
|%ergoemacs-forward-close-bracket%|forwards to next close bracket|
|%backwards-sexp%|backwards one symbolic expression (sexp)|
|%forwards-sexp%|forwards one symbolic expression (sexp)|
|%goto-line%|go to line number|
|%goto-char%|go to character offset from start of document|
|%back-to-indentation%|go to start of line skipping initial indentation|
|%ace-jump-mode%|ace jump to start of any word on screen|
|%-ace-jump-mode2%|ace jump to any character on screen|
|%ace-jump-line-mode%|ace jump to any line on screen|
|%ace-jump-mode-pop-mark%|ace jump mode pop mark|
</table>

<h2>Mark, Killing (Cut) and Deleting by direction.</h2>

<table class="compass">
th||sentence|home|word|character||character|word|end|sentence|
	<th class="right">mark</th><td>||%-mark-to-start-of-word%||%%||%mark-word%|||
		<th class="right">kill</th><td>%backward-kill-sentence%|%-kill-to-start-of-line%|%backward-kill-word% or %-backward-kill-word1%|%backward-delete-char-untabify%|%kill-region%|%delete-forward-char%|%kill-word%|%kill-line%|%kill-sentence%|
th||sentence|home|word|character||character|word|end|sentence|
</table>

<h2>Marking (Selecting)</h2>

<table class="define">
|%set-mark-command% or %-set-mark-command1%|set mark here (begin selecting)|
|%exchange-point-and-mark%|exchange mark and point|
|%mark-word%|set mark N words away (with argument prefix combo)|
|%mark-sexp%|mark forward within curent symbolic expression|
|%mark-function%|mark current function|
|%mark-paragraph%|mark current paragraph|
|%mark-page%|mark current page|
|%mark-whole-buffer%|mark entire buffer|
</table>

<h2>Copy, Cut, Paste</h2>

<table class="define">
|%kill-region%|kill (cut) marked region to kill ring|
|%kill-ring-save%|copy marked region to kill ring|
|%yank%|yank (paste) back from kill ring|
|%yank-pop%|yank (paste) previous entry from kill ring|
|%zap-to-char%|kill through next occurrence of char|
|%-kill-backwards-sexp%|kill backwards one symbolic expression (sexp)|
|%kill-sexp%|kill forwards one symbolic expression (sexp)|
</table>

<h2>Files and Buffers</h2>

<table class="define">
|%find-file%|visit a file into a buffer (existing or virtual new)|
|%save-buffer%|save the buffer to its disk file (create if virtual)|
|%write-file%|save buffer as another name|
|%save-some-buffers%|save all files asking to save each|
|%insert-file%|insert contents of another file into this buffer|
|%find-alternate-file%|replace this buffer with the file you really want|
|%read-only-mode%|toggle read-only status of buffer|
|%narrow-to-region%|narrow scope of the editor to the selected region, hides the rest of the buffer from view|
|%widen%|widen the scope of the editor to the entire buffer|
</table>

<h2>Getting Help</h2>

<table class="define">
|%-help1% or %-help2%|help prefix key|
|%help-with-tutorial%|help tutorial|
|%help-for-help%|help about help system|
|%info-emacs-manual%|emacs info manual|
|%info%|system info manual|
|%scroll-other-window%|scroll the help (other) window|
|%delete-other-windows%|remove help (and all other) window|
|%apropos-command%|apropos help matching a string|
|%describe-key-briefly%|name of function bound to a key|
|%describe-key%|help on the function bound to a key|
|%describe-function%|help on a named function|
|%describe-variable%|help on a named variable|
|%describe-mode%|help on current editing mode|
</table>

<h2>Incremental Search</h2>

<table class="define">
|%isearch-forward%|search forward|
|%isearch-backward%|search backward|
|%isearch-forward-regexp%|regular expression search forward|
|%isearch-backward-regexp%|regular expression search backward|
|%-previous-search-string%|select previous search string from history|
|%-next-search-string%|select next search string from history|
|%-exit-isearch%|exit incremental search|
|%-backspace-isearch%|undo effect of last character|
|%keyboard-quit%|abort current search|
|%%||
</table>

<h2>Search and Replace</h2>

<table class="define">
|%query-replace%|begin literal search and replace|
|%query-replace-regexp%|begin regex search and replace|
|%-replace-newline%|search or replace a literal newline|
|%-replace% or %-replace1%|replace and find next|
|%-replace-stay%|replace and stay here|
|%-replace-custom%|enter an edit mode to custom replace this match|
|%-replace-custom-exit%|finish custom replace and carry on with replacement|
|%-replace-skip% or %-replace-skip1%|skip to next without replacing|
|%-replace-all%|replace all remaining matches|
|%-replace-back%|back up to the previous match|
|%-replace-exit%|exit search and replace|
|%-replace-help%|get help while replacing|
</table>

<h2>Window and Frame Manipulation</h2>

<table class="define">
|window|frame|description|
|%delete-other-windows%|%delete-other-frames%|delete all other windows/frames|
|%split-window-below%|%make-frame-command%|split window, above and below|
|%delete-window%|%delete-frame%|delete this window|
|%split-window-right%||split window side by side|
|%scroll-other-window%||scroll other window down|
|%other-window%|%other-frame%|switch cursor to another window|
|%switch-to-buffer-other-window%|%switch-to-buffer-other-frame%|select buffer in other window|
|%display-buffer%|%display-buffer-other-frame%|display buffer in other window|
|%find-file-other-window%|%find-file-other-frame%|find file in other window|
|%find-file-read-only-other-window%|%find-file-read-only-other-frame%|find file read-only in other window|
|%dired-other-window%|%dired-other-frame%|run Dired in other window|
|%find-tag-other-window%|%find-tag-other-frame%|find tag in other window|
|%enlarge-window%||grow window taller|
|%shrink-window-horizontally%||shrink window narrower|
|%enlarge-window-horizontally%||grow window wider|
</table>

<h2>Formatting</h2>

<table class="define">
|%indent-for-tab-command%|indent current line (mode-dependent)|
|%indent-region%|indent region (mode-dependent)|
|%indent-sexp%|indent symbolic expression or scope (mode-dependent)|
|%indent-rigidly%|indent region rigidly <i>arg</i> columns|
|%comment-dwim%|smart comment/uncomment region or add comment. Kill comment if prefix argument given|
|%open-line%|insert new line after point. no indent|
|%split-line%|split line with appropriate indent|
|%delete-blank-lines%|delete blank lines around point|
|%delete-indentation%|join line with previous (with <i>arg<i>, next)|
|%delete-horizontal-space%|delete all whitespace around point|

|%just-one-space%|put exactly one space at or around point|
|%fill-paragraph%|reflow paragraph or region to the fill-column|
|%set-fill-column%|set fill-column interactively or from prefix argument|
|%set-fill-prefix%|set prefix each line starts with based on the text before point|
|%set-face%|set face (bold, italic, etc)|
</table>

<h2>Case Change</h2>

<table class="define">
|%upcase-word%|convert to uppercase the first word found after point|
|%downcase-word%|convert to lowercase the first word found after point|
|%capitalize-word%|capitalize first word found after point|
|%upcase-region%|convert all text in marked region to upper case|
|%downcase-region%|convert all text in marked region to lower case|
</table>

<h2>The Minibuffer</h2>

<table class="define">
|%minibuffer-complete%|complete as much as possible|
|%minibuffer-complete-word%|complete up to one word|
|%minibuffer-complete-and-exit%|complete and execute|
|%minibuffer-completion-help%|show possible completions|
|%repeat-complex-command%|edit and repeat the last command that used the minibuffer|
|%-minibuffer-previous%|fetch previous minibuffer input|
|%-minibuffer-next%|fetch later minibuffer input or default|
|%-minibuffer-history-isearch-reverse%|regexp search backward through history|
|%minibuffer-history-isearch-search%|regexp search forward through history|
|%minibuffer-keyboard-quit%|abort command|
|%menu-bar-open%|open the menu bar for the current frame|
</table>

<h2>Buffers</h2>

<table class="define">
|%switch-to-buffer%|select another buffer|
|%list-buffers%|list all buffers|
|%kill-buffer%|kill a buffer|
</table>

<h2>Transposing</h2>

<table class="define">
|%transpose-chars%|transpose character at point with character before point|
|%transpose-words%|transpose word at point with previous (if point at start of word) or next word|
|%transpose-lines%|transpose current line with previous line|
|%transpose-sexps%|transpose current symbolic expression with previous one. start with point at the opening character of the expression to transpose|
</table>

<h2>Spelling Check</h2>

<table class="define">
|%ispell-word%|check spelling of current word|
|%ispell-region%|check spelling of all words in region|
|%ispell-buffer%|check spelling of entire buffer|
|%flyspell-mode%|toggle on-the-fly spell checking|
</table>

<h2>Tags</h2>

<table class="define">
|%find-tag%|find the definition of a tag|
|%-find-next-tag%|find next match for last tag or regexp|
|%-find-prev-tag%|back to previous match of tag|
|%pop-tag-mark%|go back to mark before tag search began|
|%visit-tags-table%|specify a new tags file|
|%tags-search%|regexp search on all files in tags table|
|%tags-query-replace%|run query-replace on all the files|
|%tags-loop-continue%|continue last tags search or query-replace|
</table>

<h2>Shells</h2>

<table class="define">
|%shell-command%|execute a shell command|
|%async-shell-command%|execute a shell command asynchronously|
|%shell-command-on-region%|run a shell command on the region|
|%-shell-command-on-region1%|filter region through a shell command|
|%shell%|start a shell in window *shell*|
</table>

<h2>Rectangles</h2>

<table class="define">
|%rectangle-mark-mode%|toggle to rectangle mark mode|
|%copy-rectangle-to-register%|copy rectangle to a register*|
|%-delete-rectangle-to-register%|delete rectangle to register*|
|%insert-register%|insert register* into the buffer|
|%kill-rectangle%|kill rectangle shifting columns left|
|%delete-rectangle%|delete text in rectangle shifting columns left|
|%yank-rectangle%|yank rectangle inserting columns to right|
|%open-rectangle%|open rectangle, shifting text right (with tabs)|
|%clear-rectangle%|blank out the rectangle (with tabs/spaces)|
|%delete-whitespace-rectangle%|unindent rectangle, delete contiguous whitespace on each line to right of rectangle left column|
|%string-insert-rectangle%|prefix each line of rectangle with a string|
|%rectangle-number-lines%|prefix each line of rectangle with a number (use prefix arg to specify initial number)|
</table>

<p>* - a register is identified by a number, letter or other character</p>

<h2>Abbrevs</h2>

Abbrevs allow you to define short text which expands to a larger tract of boilerplate text. You can only use words for abbreviation triggers, not punctuation. When defining abbreviations use the number prefix parameter to specify how many words to include or a zero to specify the marked region.

<table class="define">
|%abbrev-mode%|Toggle abbrev mode which automatically inserts abbrev expansions on space or punctuation.|
|%dabbrev-expand%|Dynamic completion of partial word at point from somewhere else in buffer or buffers|
|%space% %dabbrev-expand%|After an initial completion will insert the next word from the original context|
|%dabbrev-completion%|Dynamic completion of partial word at point by showing a list of possibilities|
|%-dabbrev-completion16%|Dynamic completion list comes from text in all buffers|
|%expand-abbrev% or %-expand-abbrev1% or %-expand-abbrev2%|Explicitly expand abbrev before point|
|%unexpand-abbrev%|Undo the expansion of the last abbrev that expanded|
|%abbrev-prefix-mark%|Begin an abbrev expansion from current point position. i.e. re %abbrev-prefix-mark% cnst %space% would become 'reconstruct' if cnst was an abbreviation for 'construct'|
|%add-mode-abbrev% or %-add-mode-abbrev1% or %-add-mode-abbrev2%|Add a mode-local expansion for abbrev word before point or marked region|
|%inverse-add-mode-abbrev%|Add mode-local expansion for abbrev word before point or marked region|
|%add-global-abbrev%|Add global abbrev from words before point or marked region|
|%inverse-add-global-abbrev% or %-inverse-add-global-abbrev1%|Add global expansion for abbrev word before point or marked region|
|%list-abbrevs%|Show a list of abbrevs defined|
|%edit-abbrevs%|Edit the list of abbrevs|
|%write-abbrev-file%|Write all user-level abbrev definitions to a file|
</table>

<p>Example define abbreviations:</p>

<p><code>this is full text</code> %-universal-argument4% %add-mode-abbrev% <code>this</code></p>
<p>will cause 'this' to expand to four words 'this is full text' when in the current file mode.</p>

<p><code>this</code> %inverse-add-mode-abbrev% <code>this is full text</code></p>
<p>will cause 'this' to expand to 'this is full text' when in the current file mode.</p>

<h2>International Character Sets</h2>

<table class="define">
|%set-language-environment%|specify principal language|
|%list-input-methods%|show all input methods|
|%toggle-input-method%|enable or disable input methods|
|%universal-coding-system-argument%|set coding system for next command|
|%list-coding-systems%|show all coding systems|
|%prefer-coding-system%|choose preferred coding system|
</table>

<h2>Registers</h2>

<p>* - a register is identified by a number, letter or other character</p>

<table class="define">
|%copy-to-register% or %-copy-to-register2%|save region in register|
|%-delete-to-register% or %-delete-to-register2%|delete region to register|
|%insert-register% or %-insert-register2%|insert register contents into buffer. keep point before inserted text)|
|%-insert-register-move% or %-insert-register-move2%|insert register contents into buffer. move point after inserted text)|
|%point-to-register% or %-point-to-register2% or %-point-to-register3%|save value of point in register|
|%-frame-arrangement-to-register%|save arrangement of windows in frame to register|
|%jump-to-register%|jump to point saved in register|
|%-frame-arrangement-from-register%|restore frame arragement saved in register|
</table>

<h2>Keyboard Macros</h2>

<table class="define">
|%kmacro-start-macro% or %kmacro-start-macro-or-insert-counter%|start defining a keyboard macro|
|%kmacro-end-macro% or %kmacro-end-or-call-macro%|end definition of keyboard macro|
|%kmacro-end-and-call-macro% or %kmacro-end-or-call-macro%|execute last defined keyboard macro|
|%-last-kmacro-forever% or %-last-kmacro-forever2%|execute last macro forever (until end of buffer reached)|
|%-kmacro-append-to-last-macro%|append to last keyboard macro|
|%name-last-kbd-macro%|name last keyboard macro|
|%insert-kbd-macro%|insert Lisp definition in buffer|
</table>

<hr />
<a id="end" />
HEREIAM
<h2></h2>

<table class="define">
|%%||
</table>

</div>


</body>
</html>
<!--

***********************************************
***********************************************
***********************************************
***********************************************
***********************************************
***********************************************
***********************************************
***********************************************
***********************************************
***********************************************

-->
