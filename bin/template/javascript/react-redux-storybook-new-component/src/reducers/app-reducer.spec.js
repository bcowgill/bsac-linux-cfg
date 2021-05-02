/* eslint-disable prefer-arrow-callback */
import appReducer from './app-reducer'
import { setErrors } from '../actions/set-errors'
import { setTitle } from '../actions/set-title'

const suite = 'src/reducers/ appReducer Reducer'

describe(suite, function descAppReducerSuite() {
	it('should return initial state', function testAppReducer() {
		const expected = { errors: [] }
		const actual = appReducer()
		expect(actual).toEqual(expected)
	})

	it('should return current state for unknown action', function testAppReducerUnknownAction() {
		const expected = appReducer()
		const actual = appReducer(expected, {})
		expect(actual).toBe(expected)
	})

	it('should handle SET_TITLE action to set the app title', function testAppReducerSetTitleAction() {
		const state = appReducer()
		const expected = { title: 'APP TITLE', errors: [] }
		const actual = appReducer(state, setTitle('APP TITLE'))
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle SET_TITLE action to clear the app title', function testAppReducerSetTitleActionClear() {
		const state = appReducer({ title: 'DEFAULT STATE' })
		const expected = { title: undefined }
		const actual = appReducer(state, setTitle())
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle SET_ERRORS action to set some errors', function testAppReducerSetErrorsAction() {
		const state = appReducer()
		const expected = { errors: ['error one', 'error two'] }
		const actual = appReducer(state, setErrors(['error one', 'error two']))
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle SET_ERRORS action to clear errors', function testAppReducerSetErrorsAction() {
		const state = appReducer({
			errors: ['error me once', 'error me twice'],
		})
		const expected = { errors: [] }
		const actual = appReducer(state, setErrors())
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})
})
