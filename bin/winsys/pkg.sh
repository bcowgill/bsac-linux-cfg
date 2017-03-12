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
	./registry \
	./d/d/Sys/tools \
	./d/d/backup \

cp to-velda.tgz ~/Dropbox/Photos/SharedBrent/
