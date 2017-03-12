mkdir -p ./d/d/Sys/tools/perl/BSAC

cp ../ls-types.sh ./d/d/Sys/tools
cp ../ls-types.pl ./d/d/Sys/tools
cp ../perl/BSAC/FileTypes.pm ./d/d/Sys/tools/perl/BSAC

unix2dos \
	*.txt \
	./d/d/Sys/tools/*.bat \
	./d/d/backup/*.bat \
	./d/d/backup/*.txt \


tar cvzf to-velda.tgz \
	./todo-velda.txt \
	./d/d/Sys/tools \
	./d/d/backup \

rm ./d/d/Sys/tools/ls-types.*
rm ./d/d/Sys/tools/perl/BSAC/FileTypes.pm

cp to-velda.tgz ~/Dropbox/Photos/SharedBrent/
