BSAC=./d/Sys/tools/perl/BSAC
mkdir -p $BSAC

cp ../ls-types.sh ./d/Sys/tools
cp ../ls-types.pl ./d/Sys/tools
cp ../perl/BSAC/HashArray.pm $BSAC
cp ../perl/BSAC/File.pm $BSAC
cp ../perl/BSAC/FileTypes.pm $BSAC
cp ../perl/BSAC/FileTypesFound.pm $BSAC
cp ../perl/BSAC/FileTypesFoundState.pm $BSAC

unix2dos \
	*.txt \
	./d/Sys/tools/*.bat \
	./d/backup/*.bat \
	./d/backup/*.txt \


tar cvzf to-velda.tgz \
	./todo-velda.txt \
	./d/Sys/tools \
	./d/backup \

rm ./d/Sys/tools/ls-types.*
rm $BSAC/*.pm

cp to-velda.tgz ~/Dropbox/Photos/SharedBrent/
