#!/bin/bash
# listen to all music files so you can track the ones you like for a favorites play list.
ALL_LIST=all-music.lst
export SUM=played.lst
export LAST=last-played.lst
export FAV=favourite.lst
export DIR="$HOME/d/Music"

if [ ! -f "$DIR/$ALL_LIST" ]; then
	echo Generating list of all playable music...
	locate -ir '[aeiou]' | filter-music | grep -vE '\.(mod)$' > "$DIR/$ALL_LIST"
	SONGS=`wc -l < "$DIR/$ALL_LIST"`
	echo Found $SONGS songs to play.

else
	SONGS=`wc -l < "$DIR/$ALL_LIST"`
	echo List of all playable music already exists with $SONGS songs.
fi
touch "$DIR/$SUM" "$DIR/$LAST" "$DIR/$FAV"

SONGS=$SONGS perl -MFile::Slurp \
	-e '
	BEGIN
	{
		$DEBUG = 0;
		$MOD = 10;
		$played = 0;
		$stopme = "$ENV{DIR}/STOP.ME";
		print qq{To stop playing songs: touch "$stopme"\n};
		$last = read_file("$ENV{DIR}/$ENV{LAST}");
		print qq{Will resume playing songs after: $last\n};
		$find = $last;
		print qq{Last played sound file was: "$last"\n};
		open($fhPlayed, ">>", "$ENV{DIR}/$ENV{SUM}");
	}
	while (my $song = <>)
	{
		if (-f "$stopme")
		{
			system(qq{rm "$stopme"});
			print qq{Found file "$stopme", will delete it and terminate.};
			exit 0;
		}
		chomp($song);
		if ($find)
		{
			if ($find eq $song)
			{
				print qq{Last played sound file found at line: $.\n};
				$find = "";
			}
		}
		else
		{
			my $md5 = `md5sum < "$song"`;
			$md5 =~ s{\s*-\s*}{}xmsg;
			my $cmd = qq{egrep "^$md5" "$ENV{DIR}/$ENV{SUM}" > /dev/null};
			print qq{$. $md5 $song\ncmd1 $cmd\n\n} if $DEBUG > 1;
			if (system($cmd))
			{
				print $fhPlayed qq{$md5 $song\n};

				print qq{\n\nPlaying song at line $./$ENV{SONGS}\n};
				if ($played % $MOD == 0)
				{
					print qq{To save this song to your favourite list, copy this command to another shell and run it.\n};
				}
				if ($played % $MOD == 3)
				{
					print qq{\nTo stop playing songs: touch "$stopme"\n};
				}

				open($fhLast, ">", "$ENV{DIR}/$ENV{LAST}");
				print $fhLast qq{$song};
				close($fhLast);

				print qq{\necho "$song" >> "$ENV{DIR}/$ENV{FAV}"\n\n};
				$cmd = qq{sound-play.sh "$song"};
				print qq{$cmd\n} if $DEBUG;
				my $result = system($cmd);
				print qq{result: $result\n};
				++$played;
			}
			else
			{
				print qq{Skip it [$song], md5sum [$md5] matches a previously played song...\n} if $DEBUG;
			}
		}
	}
' "$DIR/$ALL_LIST"
