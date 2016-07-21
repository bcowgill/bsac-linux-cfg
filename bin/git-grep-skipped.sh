git grep -E '\.(skip|only)' | grep '.spec.js' | grep -v // | egrep --color 'skip|only'
