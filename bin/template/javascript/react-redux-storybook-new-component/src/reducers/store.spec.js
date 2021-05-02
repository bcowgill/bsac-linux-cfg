/* eslint-disable prefer-arrow-callback */

import configureStore from './store'
import rootReducer from './rootReducer'

const suite = 'src/reducers/store'

describe(suite, function descConfigureStoreSuite() {
	it('should create store with default app state', function testConfigureStore() {
		const expected = rootReducer()
		const actual = configureStore.getState()
		expect(actual).toEqual(expected)
	})
})
