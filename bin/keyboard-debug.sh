#!/bin/bash
# debug keyboard keys
#  showkey for the linux console (outside of X windows)
#showkey || xev -event keyboard
xev -event keyboard || showkey --ascii

exit
example output from xev command:

KeyPress event, serial 28, synthetic NO, window 0x3200001,
    root 0x43, subw 0x0, time 437132, (993,-30), root:(995,0),
    state 0x0, keycode 123 (keysym 0x1008ff13, XF86AudioRaiseVolume), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 28, synthetic NO, window 0x3200001,
    root 0x43, subw 0x0, time 437257, (993,-30), root:(995,0),
    state 0x0, keycode 123 (keysym 0x1008ff13, XF86AudioRaiseVolume), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False
