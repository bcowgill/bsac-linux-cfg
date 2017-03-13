# unpack archive from velda

BSAC=d/Sys/tools/perl/BSAC

sudo tar xvzf to-brent.tgz
sudo chown -R me.me d

vdiff.sh d/Sys/tools/ls-types.sh ../ls-types.sh
vdiff.sh d/Sys/tools/ls-types.pl ../ls-types.pl
vdiff.sh $BSAC/HashArray.pm ../perl/BSAC/HashArray.pm
vdiff.sh $BSAC/File.pm ../perl/BSAC/File.pm
vdiff.sh $BSAC/FileTypes.pm ../perl/BSAC/FileTypes.pm
vdiff.sh $BSAC/FileTypesFound.pm ../perl/BSAC/FileTypesFound.pm
vdiff.sh $BSAC/FileTypesFoundState.pm ../perl/BSAC/FileTypesFoundState.pm

rm d/Sys/tools/ls-types.* $BSAC/*.pm

