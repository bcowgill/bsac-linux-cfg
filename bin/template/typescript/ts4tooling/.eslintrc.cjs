module.exports = {
	extends: [
		//   "react-app",
		'plugin:import/errors',
		'plugin:import/warnings',
		'eslint:recommended',
		'plugin:@typescript-eslint/recommended',
		// MUSTDO(BSAC) this should be ok for typescript<5
		'plugin:@typescript-eslint/recommended-requiring-type-checking',
		"plugin:@typescript-eslint/strict",
		"plugin:react-hooks/recommended"
		'prettier',
	],
	parser: '@typescript-eslint/parser',
	plugins: [
		'import',
		'@typescript-eslint',
		// "cypress"
	],
	//  "env": {
	//    "cypress/globals": true
	//  },
	//  "globals": {
	//  },
	parserOptions: {
		// MUSTDO(BSAC) should be ok for typescript<5
		project: true, // suggestion is true with recommended-requiring-type-checking
		tsconfigRootDir: __dirname,
	},
	root: true,
	rules: {
		'no-console': ['error'],
		'no-fallthrough': ['error'],
		'import/order': [
			'error',
			{
				groups: [
					'builtin',
					'external',
					'internal',
					'parent',
					'sibling',
					'index',
				],
			},
		],
	},
}
