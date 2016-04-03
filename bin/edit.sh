#!/bin/bash
# send files to a running emacs instance or start up a new one if the server is not running
emacsclient --no-wait --alternate-editor=emacs $*
