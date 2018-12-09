module.exports = {
	// TODO try it "parser": "babel-eslint",
	env: {
		browser: true,
		commonjs: true,
		es6: true,
		jest: true,
		node: true,
	},
	extends: [
		'plugin:react/recommended',
		'plugin:prettier/recommended'
	],
	settings: {
		react: {
			version: '16.0',
		},
	},
	parserOptions: {
		ecmaVersion: '2019',
		ecmaFeatures: {
			jsx: true,
		},
		sourceType: 'module',
	},
	plugins: ['react'],
	globals: {},
	rules: {
		indent: [
			'off',
			'tab'
		],
		'linebreak-style': [
			'error',
			'unix'
		],
		quotes: [
			'error',
			'single'
		],
		semi: [
			'error',
			'never'
		],
	},
}
