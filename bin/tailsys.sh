#!/bin/bash
# tail a bunch of system log files
# -du show status bar up at top
# --basename show basename in status bar
# -m 1000 lines of scrollback buffer kept
# --no-repeat - don't repeat identical lines, just show a count of repeats
# -S prepend merged output with window number
# --mark-change show a banner with filename when messages change to a new file source
# --follow-all follow the file not the descriptor
# --mergeall show all files in one window
# -cS show next file with named color scheme
# -ci show next file with named color
multitail -du --basename -m 1000 --no-repeat -S --mark-change --follow-all --mergeall -cS syslog /var/log/syslog -ci red /var/log/kern.log -ci yellow /var/log/dpkg.log -ci blue /var/log/auth.log -ci green /var/log/apport.log -ci white /var/log/cups/access_log -ci red /var/log/cups/error_log

