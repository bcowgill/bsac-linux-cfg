if [ -z $DIFFER ]; then
	source `which differ.sh`
fi

for file in `find . -type f | grep -v diffetc`
do
	if diff $file /$file > /dev/null ; then
		echo same $file
	else
		echo diff $file
		# get /etc version to here
		#cp /$file $file

		# put version here to /etc
		#cp $file /$file

		# diff /etc to here
		$DIFFER /$file $file $DIFFERWAIT

		# diff here to /etc
		$DIFFER $file /$file $DIFFERWAIT
	fi
done

