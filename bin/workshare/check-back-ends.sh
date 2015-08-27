# Check all the grunts are running

GRUNTS=3
if [ `ps -ef | grep grunt | grep -v grep | wc -l` == $GRUNTS ] ; then
	echo OK all grunts are running
else
	echo NOT OK not all grunts are running should be $GRUNTS
	ps -ef | grep grunt | grep -v grep
fi

# Check all the back ends are running
if ps -ef | grep ruby | grep '2\.1' | grep rails | grep 3001 > /dev/null ; then
	echo OK ruby rails dealroom server running
else
	echo NOT OK ruby rails dealroom server is NOT running
fi

if ps -ef | grep ruby | grep rackup > /dev/null ; then
	echo OK ruby dealroom sidekiq rackup running
else
	echo NOT OK ruby dealroom sidekiq rackup is NOT running
fi

if ps -ef | grep ruby | grep '/cli start' > /dev/null ; then
	echo OK ruby content service cli start running
else
	echo NOT OK ruby content service cli start is NOT running
fi

if ps -ef | grep ruby | grep '1\.9' | grep rails > /dev/null ; then
	echo OK ruby rails cirrus server running
else
	echo NOT OK ruby rails cirrus server is NOT running
fi

if ps -ef | grep sidekiq | grep -v grep > /dev/null; then
	echo OK dealroom sidekiq is running
else
	echo NOT OK dealroom sidekiq is NOT running
fi
