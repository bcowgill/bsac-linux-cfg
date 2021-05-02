// configured in jest.config.js to run once before each test suite is executed
// runs after the test framework has been set up.

// React Testing Library global setup
// https://www.npmjs.com/package/react-testing-library
// https://react-testing-examples.com/jest-rtl/

// this adds custom jest matchers from jest-dom
// https://www.npmjs.com/package/jest-dom
import 'jest-dom/extend-expect'

// this is basically afterEach(cleanup)
// https://www.npmjs.com/package/react-testing-library#global-config
import 'react-testing-library/cleanup-after-each'

if (process.env.TEST_DEBUG) {
	// eslint-disable-next-line no-console
	console.error('in jest-setup-test-framework.js')
	// console.log('describe', describe, describe.only, describe.skip);
	// console.log('it', it, it.only, it.skip);
}
