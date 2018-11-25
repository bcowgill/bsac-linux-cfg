// snapshot.js - testing utilities for doing React snapshot testing
// prior to the version of React/jest which supports it.
/* eslint-disable import/prefer-default-export, lodash/prefer-lodash-method */

// This function allows us to paste the HTML shown on the console from
// a failed test directly into the test plan and have the test pass without
// worrying about extra spacing or surrounding double quotes.
export function prettify(src) {
	// strip off surrounding double quotes.
	// convert class= to className= attributes
	// one HTML element per line, one sentence per line
	// remove leading spaces on lines, one attribute per line
	// put closing > /> on separate line except if there are no props
	// so it is easier to read and visually compare when there are differences.
	return src
		.trim()
		.replace(/^"/, '')
		.replace(/"$/, '')
		.replace(/(\s)class=/g, '$1className=')
		.replace(/>\s*</g, '>\n<')
		.replace(/[.?!] /g, '.\n')
		.replace(/\n\s+/g, '\n')
		.replace(/\s([\w-]+="[^"]*")/g, '\n  $1')
		.replace(/\s([\w-]+=\{[^}]*})/g, '\n  $1')
		.replace(/">/g, '"\n>')
		.replace(/\s*\/>/g, '\n/>')
		.replace(/[ \t]*\n/g, '\n')
		.replace(/(<\w+)\s*(\/>)/, '$1 $2')
}

/* eslint-enable import/prefer-default-export, lodash/prefer-lodash-method */
