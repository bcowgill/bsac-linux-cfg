#!/bin/bash
# scan the javascript tests for disabled tests

MAX_SKIP=5
MAX_DISABLE=1
MAX_FETCH=0
MAX_RELAY=0
MAX_CONT=0
color=--color
color=

ERROR=0

# production build should be a production build!
PROD=`egrep -rl 'development build' webui | grep -v '/build-debug/' | grep -v 'git-check-tests' | wc -l`
if [ $PROD -gt 2 ]; then
	ERROR=$PROD
	echo ERROR: webpack has produced a development build for production
	egrep -rl 'development build' webui | perl -pne 's{\A}{    }xms' | grep -v '/build-debug/'
fi

# no debugging turned on inside the app
if git grep DEBUG | perl -pne 's{\A}{    }xms' | grep true | grep -v git-check-tests | grep app/ ; then
	echo ERROR: turn off hard coded debugging flags for production builds.
	ERROR=5
fi

# no StubSignalRClient in production app
if git grep -E "import .+? from .+?StubSignalRClient'" | perl -pne 's{\A}{	}xms' | grep -vE 'git-check-tests'; then
	echo ERROR: do not import StubSignalRClient in real code.
	ERROR=4
else
	# no SignalRClient outside of the factory
	if git grep -E "import .+? from .+?SignalRClient'" | perl -pne 's{\A}{	}xms' | grep -vE 'SignalRClientFactory|git-check-tests'; then
		echo ERROR: do not import SignalRClient, use SignalRClientFactory instead
		ERROR=5
	fi
fi

# don't confuse webpack with dots in JSX
JSX=`git grep -E '<\w+\.' | grep -v '@' | wc -l`
#if [ $JSX -gt 0 ] ; then
#	echo "ERROR: in JSX: <""do.not.confuse.poor.webpack.with.dots"
#	git grep -E '<\w+\.' | perl -pne 's{\A}{	}xms'
#	ERROR=$JSX
#fi

# anything inheriting from LoggedComponent prevents build
if git grep LoggedComponent | perl -pne 's{\A}{	}xms' | egrep 'import .+ from' | egrep -v "internals/generators/|LoggedComponent/stories/LoggedComponent.story.js|LoggedComponent/index.js" | grep $color LoggedComponent; then
	echo ERROR: inherit from BaseComponent for production builds.
	ERROR=3
fi

# too many raw Fetcher.of calls outside of the app/api tree, clean it up.
FETCHES=`git grep Fetcher.of | grep -v 'app/api/' | grep -v 'git-check-tests' | wc -l`
if [ $FETCHES -gt $MAX_FETCH ]; then
	ERROR=$FETCHES
	echo WARNING: $FETCHES uses of Fetcher.of outside the app/api/ code tree, clean it up.
	git grep Fetcher.of | grep -v 'app/api/' | grep -v 'git-check-tests' | perl -pne 's{\A}{	}xms'
else
	echo $FETCHES Fetcher.of calls found outside app/api/ a little dirt never hurt anyone.
fi

# importing CSS should only happen in components, globals go in the App/styles-bundle
CSS=`git grep 'import ' | grep css | grep -vE '/generators|(co(ntainer|mponent)s)/' | wc -l`
if [ $CSS -gt 0 ] ; then
	echo "ERROR: CSS should only be imported from App/styles-bundle or withing a component itself"
	git grep 'import ' | grep css | grep -vE '/generators|(co(ntainer|mponent)s)/' | perl -pne 's{\A}{	}xms'
	ERROR=$CSS
fi

# react-relay should only be in containers/routes
RELAY=`git grep "from 'react-relay'" | grep -vE 'app/(app.js|SignalRClientFactory.js|containers/|routes/)' | grep -v 'git-check-tests' | grep -v 'internals/generators' | wc -l`
if [ $RELAY -gt $MAX_RELAY ]; then
	ERROR=$RELAY
	echo WARNING: $RELAY react-relay uses outside the containers/routes code tree, clean it up.
	git grep -E "from 'react-relay'" | grep -vE 'app/(app.js|containers/|routes/)' | grep -v 'git-check-tests' | grep -v 'internals/generators' | perl -pne 's{\A}{	}xms'
else
	echo $RELAY react-relay uses found outside containers/routes.
fi

# components should only import components, not containers
CONT=`git grep -E 'import .+ from .+containers/' | grep -v containers/App/Style | egrep -v '^app/components/(Docuzilla|TestComponent)/' | egrep '^app/components/' | wc -l`
if [ $CONT -gt $MAX_CONT ]; then
	ERROR=$CONT
	echo WARNING: $CONT uses of containers/ from within components/, should separate relay related code into containers/
	git grep -E 'import .+ from .+containers/' | grep -v containers/App/Style | egrep -v '^app/components/Docuzilla/' | egrep '^app/components/' | perl -pne 's{\A}{	}xms'
else
	echo $CONT uses of containers/ found in components/ other than Docuzilla and TestComponent.
fi

git grep -E '^\s*(describe|it)\.skip' -- '*.spec.js' | perl -pne 's{\A}{	}xms' | egrep $color 'skip|only'

# any ocurrence of top level describe.skip() is a failure
if git grep -E '^describe\.skip' -- '*.spec.js' | egrep $color 'skip|only' > /dev/null ; then
	echo ERROR: entire test plan skipped
	git grep -E '^describe\.skip' -- '*.spec.js' | perl -pne 's{\A}{    }xms' | egrep $color 'skip|only' | perl -pne 's{\A}{\t}xms'
	ERROR=2
fi

# any ocurrence of .only() is a failure
if git grep -E '^\s*(describe|it)\.only' -- '*.spec.js' | egrep $color 'skip|only' > /dev/null ; then
	echo ERROR: tests being skipped because of only
	git grep -E '^\s*(describe|it)\.only' -- '*.spec.js' | perl -pne 's{\A}{	}xms' | egrep $color 'skip|only'| perl -pne 's{\A}{    }xms'
	ERROR=1
fi

# too many skipped tests is a failure
SKIPS=`git grep -E '^\s*(describe|it)\.skip' -- '*.spec.js' | wc -l`

if [ $SKIPS -gt $MAX_SKIP ]; then
	ERROR=$SKIPS
	echo ERROR: $SKIPS skipped tests or test suites found
else
	echo $SKIPS skips found, no big deal
fi

# too many deactivated tests is a failure
FILES=`find app -name *.spec.js`
SKIPS=0
for F in $FILES
	do LINES=`egrep -v '^\s*//' $F | wc -l`
		if [ $LINES -lt 10 ]; then
			SKIPS=$[$SKIPS + 1]
			echo $LINES: $F | perl -pne 's{\A}{    }xms'
		fi
	done
if [ $SKIPS -gt $MAX_DISABLE ]; then
	ERROR=$SKIPS
	echo ERROR: $SKIPS disabled test suites found
else
	echo $SKIPS disabled test suites found, no big deal
fi

exit $ERROR
