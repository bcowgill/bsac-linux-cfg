# unpack archive from velda

sudo tar xvzf to-brent.tgz
sudo chown -R me.me d
vdiff.sh d/Sys/tools/ls-types.sh ../ls-types.sh
vdiff.sh d/Sys/tools/ls-types.pl ../ls-types.pl
vdiff.sh d/Sys/tools/perl/BSAC/FileTypes.pm ../perl/BSAC/FileTypes.pm
rm d/Sys/tools/ls-types.* d/Sys/tools/perl/BSAC/FileTypes.pm
