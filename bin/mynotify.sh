#!/bin/bash
# show a notification using whatever notifier is installed

function mynotify {
	local title message
	title="$2"
	message="$1"
	which osascript > /dev/null && osascript -e "display notification \"$message\" with title \"$title\""
	which notify > /dev/null && notify -t "$title" -m "$message"
	if which notify-send > /dev/null ; then
		if [ -z "$title" ]; then
			title="check-system.sh"
			if [ -z "$message" ]; then
				return
			fi
		fi
		notify-send --expire-time=15000 "$title" "$message"
	fi

}

mynotify "$1" "$2"
