#!/bin/bash
# run the cirrus back end locally

LOGC=/tmp/bcowgill/build-cirrus-local-cirrus.log
LOGD=/tmp/bcowgill/build-cirrus-local-dealroom.log

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

rm $LOGC $LOGD
touch $LOGC
touch $LOGD

# Get back ends going

source $HOME/.rvm/scripts/rvm
rvm use 2.1.5
redis-server &

pushd ~/projects/dealroom
( RAILS_RELATIVE_URL_ROOT='/dealroom' bundle exec rails server -p 3001 2>&1 | tee --append $LOGD ) &
popd

pushd ~/projects/cirrus
	bundle exec rake frontend_assets:clean 2>&1 | tee --append $LOGC
	bundle exec rake frontend_assets:download 2>&1 | tee --append $LOGC

	( bundle exec rails server 2>&1 | tee --append $LOGC ) &
popd

# Get grunt tasks running in the dealroom
pushd ~/projects/dealroom-ui
	if [ ${GRUNT:-1} == 1 ]; then
		grunt build 2>&1 | tee --append $LOGC
		( grunt watch 2>&1 | tee --append $LOGC ) &
		( grunt serve:tests 2>&1 | tee --append $LOGC ) &
	fi
popd

# Get grunt tasks running for new-ui
pushd ~/projects/new-ui
	if [ ${GRUNT:-1} == 1 ]; then
		grunt build 2>&1 | tee --append $LOGC
		( grunt serve --cirrus-env=local 2>&1 | tee --append $LOGC ) &
	fi
popd

echo In the browser, clear your cookies and go to http://localhost:9000
echo and login successfuly with u: admin@email.com pass: fishpaste

echo build processes are logging to files:
echo less -R $LOGC
echo less -R $LOGD

