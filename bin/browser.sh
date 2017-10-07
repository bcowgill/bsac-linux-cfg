# cross-platform browser launcher
if [ -e /Applications ]; then
	if [ -e "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
		open -a "Google Chrome" $*
		exit 0
	fi

	if [ -e /Applications/Firefox.app/Contents/MacOS/firefox ]; then
		open -a FireFox $*
		exit 0
	fi

	if [ -e /Applications/Safari.app/Contents/MacOS/Safari ]; then
		open -a Safari $*
		exit 0
	fi
else
	chromium-browser $* &
fi
