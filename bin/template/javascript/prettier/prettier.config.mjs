/* eslint-env node */
// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

// The package.json prettier option has priority over this file.

/** @type {import("prettier").Config} */
const config = {
	experimentalTernaries: true,
	endOfLine: 'lf',
	useTabs: true,
	tabWidth: 4,
	printWidth: 80,
	proseWrap: 'preserve', // markdown
	trailingComma: 'all',
	semi: false,
	singleQuote: true,
	quoteProps: 'as-needed',
	jsxSingleQuote: false,
	singleAttributePerLine: true,
	arrowParens: 'always',
	bracketSameLine: false,
	bracketSpacing: true,
	htmlWhitespaceSensitivity: 'css',
	overrides: [
		{
			files: ['package*.json{,5}'],
			options: {
				parser: 'json',
				useTabs: false,
				tabWidth: 2,
				'f-q': true,
			},
			'f-q': true,
		},
		{
			// Using prettier with this config file will convert unquoted keys object
			// into a quoted-keys JSON for pasting into package.json
			// ./node_modules/.bin/prettier --config prettier.config.mjs --write prettier.config.mjs
			'force-quoted':
				'a single quoted key, with quoteProps "consistent" will make them all quoted',
			files: ['prettier.config.mjs'],
			options: {
				useTabs: false,
				tabWidth: 2,
				singleQuote: false,
				quoteProps: 'consistent',
				trailingComma: 'none',
				'f-q': true,
			},
		},
	],
	'f-q': true,
}

export default config
