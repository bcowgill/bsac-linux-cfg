#!/bin/bash
# watch for key events and show info
# https://wiki.archlinux.org/index.php/Extra_keyboard_keys
# https://wiki.archlinux.org/index.php/Map_scancodes_to_keycodes
# https://wiki.archlinux.org/index.php/Extra_keyboard_keys_in_console
# https://wiki.archlinux.org/index.php/Xmodmap
# http://cweiske.de/howto/xmodmap/allinone.html


if [ ${1:-nothing} != -root ]; then
	echo use -root option to watch root window key events
fi

sleep 1

#xev $* | egrep -A 6 'KeymapNotify|KeyPress|KeyRelease'

xev $* | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
