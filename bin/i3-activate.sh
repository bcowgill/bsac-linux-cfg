#!/bin/bash
# after all of i3 startup activate the right workspace/window if possible
sleep 9
i3-msg 'workspace 5; focus right; workspace 1'
