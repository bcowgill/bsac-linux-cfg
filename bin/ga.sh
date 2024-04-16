#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

ORIG="template/playwright/__vendor__/playwright-core/client/harRouter.js.orig \
	template/playwright/__vendor__/playwright-core/client/page.js.orig \
	template/playwright/__vendor__/playwright-core/server/dispatchers/dispatcher.js.orig \
	template/playwright/__vendor__/playwright-core/server/dispatchers/localUtilsDispatcher.js.orig \
	cfg/raspberrypi/etc/rc.local.orig"

git add cfg/.gconf/apps/gnome-terminal/profiles/Default/%gconf.xml
clean.sh
git checkout -- $ORIG

WORKON="wip Updated gconf.xml settings" git commit
