# find sound files which cannot be played directly
find-sounds.sh | grep -vE '\.(mp3|wav|ogg|mid)$'
