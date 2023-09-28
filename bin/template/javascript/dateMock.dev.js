const SaveDate = Date;

/**
 * Mock the Date constructor so that today’s date is something different.
 * @param {string} when - the string representing today’s date for testing purposes.
 * @returns {DateConstructor} the new date constructor with a mock current date.
 * @note side effect sets the global Date constructor to a Jest mock function.
 */
export function mockDate(when) {
	const mock = new Date(when);
	const dateSpy = jest.spyOn(global, "Date").mockImplementation((value) => (value ? new SaveDate(value) : mock));
	Date.now = () => mock.valueOf();
	Date.parse = SaveDate.parse;
	Date.UTC = SaveDate.UTC;
	return dateSpy;
}
