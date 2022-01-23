#!/bin/bash

WIDTH=$1
HEIGHT=$2
shift
shift
echo "<!DOCTYPE html>"
echo "<html><head><title>Image gallery with thumbnails</title><head>"
echo "<body>"
for image in $*; do
	echo "<a target='_blank' href='$image'><h1>$image</h1><img width='$WIDTH' height='$HEIGHT' src='$image'/></a>"
done
echo "</body></html>"
