these are the preferences files for dia diagram program with white or dark background.

to use one or the other just copy them into place.

cp -r dia-dark/* ~/.dia
cp -r dia-white/* ~/.dia

vdiff.sh .dia/ ~/bin/cfg/dia-prefs/dia-white/
vdiff.sh cfg/dia-prefs/dia-white/ cfg/dia-prefs/dia-dark/


every now and then they should be backed up againg and diffed to the other shade to keep the recent files up to date.
