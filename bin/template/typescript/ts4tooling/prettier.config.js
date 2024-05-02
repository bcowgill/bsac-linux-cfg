/* eslint-env node */
// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

// The package.json prettier option has priority over this file.

/** @type {import("prettier").Config} */
module.exports = {
	// not supported in this version of prettier 2.8.4
	// experimentalTernaries: true,
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
			},
		},
	],
}
