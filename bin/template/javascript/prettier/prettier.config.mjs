// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

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
	jsxSingleQuote: false,
	singleAttributePerLine: false,
	arrowParens: 'always',
	bracketSameLine: false,
	bracketSpacing: true,
	quoteProps: 'as-needed',
	htmlWhitespaceSensitivity: 'css',
	overrides: [
		{
			files: ['package*.json'],
			options: {
				parser: 'json',
				useTabs: false,
				tabWidth: 2,
			},
		},
	],
}

export default config
