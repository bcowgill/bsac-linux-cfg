/* eslint-env node */
module.exports = {
	semi: false,
	singleQuote: true,
	quoteProps: 'as-needed',
	singleAttributePerLine: true,
	bracketSameLine: false,
	arrowParens: 'always',
	trailingComma: 'all',
	tabWidth: 4,
	useTabs: true,
	overrides: [
		{
			files: 'package*.json{,5}',
			options: {
				useTabs: false,
				tabWidth: 2,
			},
		},
	],
}
