#!/usr/bin/env perl
# display an emacs key reference

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $VERSION = 0.1;
our $DEBUG = 1;

our $SHORTEN_KEYS = 0;
our $USE_META = 0;

# key combination/chord
sub k {
    my $combo = join(" ", map { "<kbd>$ARG</kbd>" } @ARG);
    if ($USE_META) {
	$combo =~ s{Alt-}{Meta-}xmsg;
    }
    if ($SHORTEN_KEYS) {
	$combo =~ s{Ctrl-}{C-}xmsg;
	$combo =~ s{Shift-}{S-}xmsg;
	$combo =~ s{Meta-}{M-}xmsg;
	$combo =~ s{Alt-}{A-}xmsg;
    }
    return $combo;
}

# variable key combination like Alt-N for Alt-0, Alt-1, ...
sub kk {
    my ($prefix, $param) = @ARG;
    return "<kbd>$prefix<i>$param</i></kbd>"
}

# command line function
sub fn {
    my ($function) = @ARG;
    return k('Alt-x') . " <code>$function</code>";
}

# key combination with parameter
sub p {
    my ($combo, $param) = @ARG;
    return k($combo) . " <i>$param</i>";
}

my $rhSub = {
	'' => '',
	MODE => 'Emacs',

	# Params / Prefix keys
	'universal-argument' => p('Ctrl-u', 'number/-number'),
	'digit-argument' => kk('Alt-', 'N'),
	'negative-argument' => k('Alt--'),
	'-neg-arg1' => k('Ctrl--'),
	'-neg-arg2' => k('Ctrl-Alt--'),
	'quoted-insert' => p('Ctrl-q', 'char'),

	# Compass rose
	'backward-page' => k('Ctrl-x', '['),
	'backward-paragraph' => k('Alt-{'),
	'backward-sentence' => k('Alt-b'),
	'move-beginning-of-line' => k('Ctrl-a'),
	'backward-word' => k('Alt-b'),
	'backward-char' => k('Ctrl-b'),
	'recenter-top-bottom' => k('Ctrl-l'),
	'forward-char' => k('Ctrl-f'),
	'forward-word' => k('Alt-f'),
	'move-end-of-line' => k('Ctrl-e'),
	'forward-sentence' => k('Alt-e'),
	'forward-paragraph' => k('Alt-}'),
	'forward-page' => k('Ctrl-x', ']'),
	'beginning-of-buffer' => k('Alt-<'),
	'scroll-down-command' => k('Alt-v'),
	'previous-line' => k('Ctrl-p'),
	'next-line' => k('Ctrl-n'),
	'scroll-up-command' => k('Ctrl-v'),
	'end-of-buffer' => k('Alt->'),
	'scroll-left' => k('Ctrl-x', '<'),
	'scroll-right' => k('Ctrl-x', '>'),

	# Motion
	'goto-line' => k('Alt-g', 'g'),
	'goto-char' => k('Alt-g', 'c'),
	'back-to-indentation' => k('Alt-m'),
	'backwards-sexp' => k('Ctrl-Alt-b'),
	'forwards-sexp' => k('Ctrl-Alt-f'),

	# Mark / Select
	'set-mark-command' => k('Ctrl-Space'),
	'-set-mark-command1' => k('Ctrl-@'),
	'exchange-point-and-mark' => k('Ctrl-x', 'Ctrl-x'),
	'mark-word' => k('Alt-@'),
	'-mark-to-start-of-word' => k('Alt--', 'Alt-@'),
	'mark-paragraph' => k('Alt-h'),
	'mark-page' => k('Ctrl-x', 'Ctrl-p'),
	'mark-sexp' => k('Ctrl-Alt-@'),
	'mark-function' => k('Ctrl-Alt-h'),
	'mark-whole-buffer' => k('Ctrl-x', 'h'),

	# Delete / Cut
	'backward-delete-char-untabify' => k('Backspace'),
	'delete-forward-char' => k('Delete'),
	'delete-char' => k('Ctrl-d'),
	'backward-kill-word' => k('Ctrl-Backspace'),
	'-backward-kill-word1' => k('Alt-Backspace'),
	'kill-word' => k('Alt-d'),
	'kill-line' => k('Ctrl-k'), # delete to end of line
	'-kill-to-start-of-line' => k('Alt-0', 'Ctrl-k'), # zero arg, kill-line
	'kill-sentence' => k('Alt-k'),
	'backward-kill-sentence' => k('Ctrl-x', 'Backspace'),
	'-kill-backwards-sexp' => k('Alt--', 'Ctrl-Alt-k'), # negative arg, kill-sexp
	'kill-sexp' => k('Ctrl-Alt-k'),
	'kill-region' => k('Ctrl-w'),
	'kill-ring-save' => k('Alt-w'),
	'yank' => k('Ctrl-y'),
	'yank-pop' => k('Alt-y'),
	'zap-to-char' => p('Alt-z', 'char'),

	# Exit
	'suspend-frame' => k('Ctrl-z'),
	'save-buffers-kill-terminal' => k('Ctrl-x', 'Ctrl-c'),

	# Files and Buffers
	'find-file' => k('Ctrl-x', 'Ctrl-f'),
	'save-buffer' => k('Ctrl-x', 'Ctrl-s'),
	'save-some-buffers' => k('Ctrl-x', 's'),
	'insert-file' => k('Ctrl-x', 'i'),
	'find-alternate-file' => k('Ctrl-x', 'Ctrl-v'),
	'write-file' => k('Ctrl-x', 'Ctrl-w'),
	'read-only-mode' => k('Ctrl-x', 'Ctrl-q'),

	# Help
	'-help1' => k('Ctrl-h'),
	'-help2' => k('F1'),
	'help-with-tutorial' => k('Ctrl-h', 't'),
	'delete-other-windows' => k('Ctrl-x', '1'),
	'scroll-other-window' => k('Ctrl-Alt-v'),
	'apropos-command' => k('Ctrl-h','a'),
	'describe-key-briefly' => k('Ctrl-h', 'c'),
	'describe-key' => k('Ctrl-h', 'k'),
	'describe-function' => k('Ctrl-h', 'f'),
	'describe-mode' => k('Ctrl-h', 'm'),

	# Error Recovery
	'keyboard-quit' => k('Ctrl-g'),
	'recover-session' => \&fn,
	'undo' => k('Ctrl-/'),
	'-undo2' => k('Ctrl-_'),
	'-undo1' => k('Ctrl-x', 'u'),
	'revert-buffer' => \&fn,
	'redraw-display' => \&fn,

	# Incremental Search
	'isearch-forward' => k('Ctrl-s'),
	'isearch-backward' => k('Ctrl-r'),
	'isearch-forward-regexp' => k('Ctrl-Alt-s'),
	'isearch-backward-regexp' => k('Ctrl-Alt-r'),
	'-previous-search-string' => k('Alt-p'),
	'-next-search-string' => k('Alt-n'),
	'-exit-isearch' => k('Enter'),
	'-backspace-isearch' => k('Backspace'),

	# Search and Replace
	'query-replace' => k('Alt-%'),
	'query-replace-regexp' => k('Ctrl-Alt-%'),
	'-replace' => k('Space'),
	'-replace1' => k('y'),
	'-replace-skip' => k('Backspace'),
	'-replace-skip1' => k('n'),
	'-replace-stay' => k(','),
	'-replace-all' => k('!'),
	'-replace-help' => k('Ctrl-h'),
	'-replace-back' => k('^'),
	'-replace-exit' => k('Enter'),
	'-replace-newline' => k('Ctrl-q', 'Ctrl-j'),
	'-replace-custom' => k('Ctrl-r'),
	'-replace-custom-exit' => k('Ctrl-Alt-c'),

};

while (my $line = <DATA>) {
	$line =~ s{
		\%([^\%]*)\%
    }{
		if ($rhSub->{$1}) {
			if (ref($rhSub->{$1})) {
				$rhSub->{$1}->($1);
			}
			else { 
				$rhSub->{$1};
			}
		}
		else {
			$1
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

	print "$line";
}

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

__DATA__
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>%MODE% Key Binding Reference</title>

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

<h1>%MODE% Key Binding Reference</h1>

<h2>Modifier Keys</h2>

<table class="define">
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
|%backwards-sexp%|backwards one symbolic expression (sexp)|
|%forwards-sexp%|forwards one symbolic expression (sexp)|
|%goto-line%|go to line number|
|%goto-char%|go to character offset from start of document|
|%back-to-indentation%|go to start of line skipping initial indentation|
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

<h2>Leaving Emacs</h2>

<table class="define">
|%suspend-frame%|suspend Emacs (or iconify it under X)|
|%save-buffers-kill-terminal%|exit Emacs ask to save|
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
</table>

<h2>Getting Help</h2>

<table class="define">
|%-help1% or %-help2%|help prefix key|
|%help-with-tutorial%|help tutorial|
|%scroll-other-window%|scroll the help (other) window|
|%delete-other-windows%|remove help (and all other) window|
|%apropos-command%|apropos help matching a string|
|%describe-key-briefly%|name of function bound to a key|
|%describe-key%|help on the function bound to a key|
|%describe-function%|help on a named function|
|%describe-mode%|help on current editing mode|
</table>

<h2>Error Recovery</h2>

<table class="define">
|%keyboard-quit%|abort a partially typed or executing command|
|%recover-session%|recover files lost by a system crash|
|%undo% or %-undo1% or %-undo2%|undo an unwanted change|
|%revert-buffer%|revert a buffer to what is in the disk file|
|%redraw-display%|redraw screen|
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

<hr />
<h2></h2>

<table class="define">
|%%||
</table>

'-' => k('Ctrl-'),

</div>


</body>
</html>
