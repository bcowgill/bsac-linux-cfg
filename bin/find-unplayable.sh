#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# find sound files which cannot be played directly
# currently cannot play: ac3, m4a, wma, mid (plays, but no sound output)
# cmus can play: aiff flac mp2 mp3 wav ogg
# m3u is a playlist file
find-sounds.sh | grep -vE '\.(aiff|flac|m3u|mp[23]|ogg|wav)$'
