# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

echo `date` debug-shell:.bashrc entered >> ~/startup.log

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

echo `date` debug-shell:.bashrc is interactive >> ~/startup.log
