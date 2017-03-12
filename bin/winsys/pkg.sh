mkdir -p ./d/Sys/tools/perl/BSAC

cp ../ls-types.sh ./d/Sys/tools
cp ../ls-types.pl ./d/Sys/tools
cp ../perl/BSAC/FileTypes.pm ./d/Sys/tools/perl/BSAC

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
rm ./d/Sys/tools/perl/BSAC/FileTypes.pm

cp to-velda.tgz ~/Dropbox/Photos/SharedBrent/
