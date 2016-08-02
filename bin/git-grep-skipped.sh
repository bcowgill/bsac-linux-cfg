git grep -E '^\s*(describe|it)\.(skip|only)' -- '*.spec.js' | egrep --color 'skip|only'
