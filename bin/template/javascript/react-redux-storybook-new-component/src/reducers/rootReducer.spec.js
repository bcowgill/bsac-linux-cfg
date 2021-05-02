/* eslint-disable prefer-arrow-callback */
import rootReducer from './rootReducer'

const suite = 'src/util/rootReducer'

describe(suite, function descRootReducerSuite() {
	it('should return initial state', function testRootReducer() {
		const expected = { data: [], app: { errors: [] } }
		const actual = rootReducer()
		expect(actual).toEqual(expected)
	})

	it('should return current state for unknown action', function testRootReducerUnknownAction() {
		const expected = rootReducer()
		const actual = rootReducer(expected, {})
		expect(actual).toBe(expected)
	})
})
