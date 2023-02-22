/* eslint-env node */
/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
	verbose: true,
	preset: 'ts-jest',
	testEnvironment: 'node',
	rootDir: 'src/', // to prevent jest processing transpiled .js files
	testRegex: '.test.(ts|tsx)$',
	coverageDirectory: '../coverage', // relative to rootDir
	collectCoverageFrom: [
		// relative to rootDir
		'**/*.{cts,mts,ts,tsx}',
		// MUSTDO(BSAC) Temporary until fully index.ts, pii.ts covered
		'!index.ts',
		'!common.ts',
		'!pii.ts',
		'**/*.d.ts',
		'!**/*.test.ts',
		'!**/*.time.ts',
		'!setupTests.ts',
		'!__*__/**',
		'!**/__*__/*',
	],
	coverageThreshold: {
		global: {
			branches: 85,
			functions: 85,
			lines: 85,
			statements: 85,
		},
	},
	coverageReporters: ['text', 'html', 'cobertura'],
}
