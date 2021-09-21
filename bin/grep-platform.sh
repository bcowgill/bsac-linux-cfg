#!/bin/bash
# grep-platform.sh | perl -pne 's{\A(.+?):.*\z}{$1\n}xms' | sort | uniq
git grep -E '\b(window|document|navigator|history|(local|session)Storage)\.' \
	| grep -vE ':\s*//' \
	| grep -vE 'window\.(digitalData|AppMeasurement|__|console)' \
	| grep -vE '(__.+__|/integration|docs|cypress)/' \
	| grep -vE 'src/(setupTests|utils/platform).js:' \
