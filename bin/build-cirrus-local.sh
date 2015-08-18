#!/bin/bash
# run the cirrus back end locally
# may need to run this as a bash login shell bash --login -c build-cirrus-local.sh

# check the branches you have for dealroom, cirrus, dealroom-ui, and new-ui before running the build
# probably want them all te be sysqa or edge to start with.
# git clone http://github.com/workshare/content-service.git
# rvm install ruby-1.9.3-p392
# apt-get install graphviz libxml2-dev libxslt-dev

LOGC=/tmp/bcowgill/build-cirrus-local-cirrus.log
LOGD=/tmp/bcowgill/build-cirrus-local-dealroom.log
LOGSK=/tmp/bcowgill/build-cirrus-local-dealroom-sidekiq.log
LOGDU=/tmp/bcowgill/build-cirrus-local-dealroom-ui.log
LOGNU=/tmp/bcowgill/build-cirrus-local-new-ui.log
LOGCS=/tmp/bcowgill/build-cirrus-local-content-service.log

#GRUNT=0

# Configure changes to run things locally
pushd ~/projects/new-ui

if egrep 'port:\s*3001' Gruntfile.js > /dev/null ; then
	echo OK Gruntfile.js configured for local dealroom back end server
else
	echo NOT OK MAYBE Gruntfile.js is not configured for local dealroom back end server, will try to configure it.

	# Modify this config in the Gruntfile to enable local dealroom server
	# /* uncomment to use a local server for dealroom
	# {
	#     context: '/dealroom',
	#     host: 'localhost',
	#     port: 3000
	# },
	# */
	perl -i.bak -e '
		local $/ = undef;
		$file = <>;
		$file =~ s{
			(/\* \s+ uncomment [^\n]+ dealroom \s*?)
			(\n \s* \{ [^\}]+ port: \s* )
			3000
			([^\}]+ \} \s* , \s* )
			\*/
		}{$1 */${2}3001$3/* MUSTDO NOT COMMIT THE ABOVE LOCAL PORT CHANGE */}xmsg;
		print $file;
	' Gruntfile.js
fi

if egrep 'port:\s*3001' Gruntfile.js > /dev/null ; then
	echo OK Gruntfile.js configured for local dealroom back end server
else
	echo NOT OK Gruntfile.js is not configured for local dealroom back end server.
	exit 1
fi
popd

pushd ~/projects/dealroom

if [ `egrep ':9000' config/application.yml | wc -l` == 4 ] ; then
	echo OK config/application.yml configured for local dealroom back end server
else
	echo NOT OK MAYBE config/application.yml is not configured for local dealroom back end server, will try to configure it.

	#users_client:
	#   development: &default
	#-    url: http://localhost:3000/
	#+    url: http://localhost:9000/
	perl -i.bak -e '
		local $/ = undef;
		$file = <>;
		$file =~ s{
			(
				[\ \t]* (users_client|home_path|cirrus|transact_path) : \s+
				development: .+?
				url: .+?
				)
				:3000 ([^\n]*) \n
		}{\n# MUSTDO DONT COMMIT THIS LOCAL PORT CHANGE\n$1:9000$3\n# MUSTDO DONT COMMIT THIS LOCAL PORT CHANGE\n}xmsg;
		print $file;
	' config/application.yml
fi

if [ `egrep ':9000' config/application.yml | wc -l` == 4 ] ; then
	echo OK config/application.yml configured for local dealroom back end server
else
	echo NOT OK config/application.yml is not configured for local dealroom back end server.
	egrep ':9000' config/application.yml
	exit 1
fi

popd

# Terminate any running builds now
killall --wait --regexp ruby
if [ ${GRUNT:-1} == 1 ]; then
	killall --wait grunt
fi

rm $LOGC $LOGD $LOGSK $LOGDU $LOGNU $LOGCS
touch $LOGC
touch $LOGD
touch $LOGSK
touch $LOGDU
touch $LOGNU
touch $LOGCS

# Get back ends going

source $HOME/.rvm/scripts/rvm
rvm use 2.1.5
redis-server &

pushd ~/projects/dealroom
( RAILS_RELATIVE_URL_ROOT='/dealroom' bundle exec rails server -p 3001 2>&1 | tee --append $LOGD ) &
( bundle exec sidekiq 2>&1 | tee --append $LOGSK )
popd

pushd ~/projects/cirrus
	rvm use ruby-1.9.3-p551
	bundle exec rake frontend_assets:clean 2>&1 | tee --append $LOGC
	bundle exec rake frontend_assets:download 2>&1 | tee --append $LOGC

	( bundle exec rails server 2>&1 | tee --append $LOGC ) &
popd

pushd ~/projects/content-service
	rvm use ruby-1.9.3-p551
	mkdir -p log
	bundle exec ./cli start
popd

# Get grunt tasks running in the dealroom
pushd ~/projects/dealroom-ui
	if [ ${GRUNT:-1} == 1 ]; then
		grunt build 2>&1 | tee --append $LOGDU
		( grunt watch 2>&1 | tee --append $LOGDU ) &
		( grunt serve:tests 2>&1 | tee --append $LOGDU ) &
	fi
popd

# Get grunt tasks running for new-ui
pushd ~/projects/new-ui
	if [ ${GRUNT:-1} == 1 ]; then
		grunt build 2>&1 | tee --append $LOGNU
		( grunt serve --cirrus-env=local 2>&1 | tee --append $LOGNU ) &
	fi
popd

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


echo In the browser, clear your cookies and go to http://localhost:9000
echo and login successfuly with u: admin@email.com pass: fishpaste

echo build processes are logging to files:
echo less -R $LOGC
echo less -R $LOGD
echo less -R $LOGSK
echo less -R $LOGDU
echo less -R $LOGNU

