for file in `find . -type f | grep -v diffetc`
do
	if diff $file /$file > /dev/null ; then
		echo same $file
	else
		echo diff $file
	fi
done

