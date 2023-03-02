/* eslint-env node */
/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
	verbose: true,
	preset: 'ts-jest',
	testEnvironment: 'jsdom',
	rootDir: 'src/', // to prevent jest processing transpiled .js files
	testRegex: '.test.(ts|tsx)$',
	coverageDirectory: '../coverage', // relative to rootDir
	collectCoverageFrom: [
		// relative to rootDir
		'**/*.{cts,mts,ts,tsx}',
		'**/*.d.ts',
		'!**/*.test.ts',
		'!**/*.time.ts',
		'!setupTests.ts',
		'!__*__/**',
		'!**/__*__/*',
	],
	coverageThreshold: {
		global: {
			branches: 98,
			functions: 98,
			lines: 98,
			statements: 98,
		},
	},
	coverageReporters: ['text', 'html', 'cobertura'],
}
