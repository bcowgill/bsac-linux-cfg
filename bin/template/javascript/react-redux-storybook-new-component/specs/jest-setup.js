// configured in jest.config.js to run once before each test suite is executed
// can perform global test setup for uniformity.
if (process.env.TEST_DEBUG) {
	// eslint-disable-next-line no-console
	console.error('in jest-setup.js')
}
