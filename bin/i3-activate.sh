#!/bin/bash
# after all of i3 startup activate the right workspace/window if possible
build=$1
shell=$2
sleep 9
i3-msg "workspace $build; focus right; workspace $shell"
