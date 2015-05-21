for file in `find . -type f | grep -v diffetc`
do
	diff $file /$file > /dev/null
	echo $file $?
done

