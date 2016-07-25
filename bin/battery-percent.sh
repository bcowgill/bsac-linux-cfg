#upower --show-info /org/freedesktop/UPower/devices/battery_BAT1 \
upower --show-info `upower --enumerate` \
    | egrep 'percentage' \
    | perl -pne 'chomp; s{\s*(percentage:\s*)}{}xms; $_ .= "🔋 "'
