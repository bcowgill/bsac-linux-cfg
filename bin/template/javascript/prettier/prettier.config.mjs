// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

// The package.json prettier option has priority over this file.

/** @type {import("prettier").Config} */
const config = {
	'f-q': true,
	'experimentalTernaries': true,
	'endOfLine': 'lf',
	'useTabs': true,
	'tabWidth': 4,
	'printWidth': 80,
	'proseWrap': 'preserve', // markdown
	'trailingComma': 'all',
	'semi': false,
	'singleQuote': true,
	'jsxSingleQuote': false,
	'singleAttributePerLine': false,
	'arrowParens': 'always',
	'bracketSameLine': false,
	'bracketSpacing': true,
	'quoteProps': 'as-needed',
	'htmlWhitespaceSensitivity': 'css',
	'overrides': [
		{
			'f-q': true,
			'files': ['package*.json'],
			'options': {
				'f-q': true,
				'parser': 'json',
				'useTabs': false,
				'tabWidth': 2,
			},
		},
		{
			// Using prettier with this config file will convert unquoted keys object
			// into a quoted-keys JSON for pasting into package.json
			// ./node_modules/.bin/prettier --config prettier.config.mjs --write prettier.config.mjs
			'force-quoted':
				'a single quoted key, with quoteProps "consistent" will make them all quoted',
			'files': ['prettier.config.mjs'],
			'options': {
				'f-q': true,
				'useTabs': false,
				'tabWidth': 2,
				'singleQuote': false,
				'quoteProps': 'consistent',
				'trailingComma': 'none',
			},
		},
	],
}

export default config
