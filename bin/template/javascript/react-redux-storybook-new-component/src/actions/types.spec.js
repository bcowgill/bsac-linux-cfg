// a simple test of a facade file for unit test coverage
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import facadeTestHelper from 'specs/test-tools/facade-helper'
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import * as Facade from './types'

const suite = 'src/actions/types Facade'

/* eslint-disable prefer-arrow-callback */
describe(suite, function descActionTypesFacadeSuite() {
	const exportHelper = {
		suite,
		exportsTested: 0,
		totalExports: 5,
		namedExports: [
			'SET_ERRORS',
			'SET_TITLE',
		],
		exportChecks: {
			SET_ERRORS: { type: 'enum' },
			SET_TITLE: { type: 'enum' },
		},
	}

	facadeTestHelper(exportHelper, Facade)
})
