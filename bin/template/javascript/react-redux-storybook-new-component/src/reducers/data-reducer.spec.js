/* eslint-disable prefer-arrow-callback */
import dataReducer from './data-reducer'
import {
	VALIDATE_USER_REQUEST,
	VALIDATE_USER_SUCCESS,
	VALIDATE_USER_FAILURE,
} from '../actions/types'

const suite = 'src/reducers/ dataReducer Reducer'

describe(suite, function descDataReducerSuite() {
	it('should return initial state', function testDataReducer() {
		const expected = []
		const actual = dataReducer()
		expect(actual).toEqual(expected)
	})

	it('should return current state for unknown action', function testDataReducerUnknownAction() {
		const expected = dataReducer()
		const actual = dataReducer(expected, {})
		expect(actual).toBe(expected)
	})

	it('should handle VALIDATE_USER_REQUEST action', function testDataReducerRequestAction() {
		const state = dataReducer()
		const expected = []
		const actual = dataReducer(state, {
			payload: { bogus: 'information' },
			type: VALIDATE_USER_REQUEST,
		})
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle VALIDATE_USER_SUCCESS action', function testDataReducerSuccessAction() {
		const state = dataReducer()
		const expected = [{ some: 'information' }]
		const actual = dataReducer(state, {
			payload: [{ some: 'information' }],
			type: VALIDATE_USER_SUCCESS,
		})
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle VALIDATE_USER_FAILURE action', function testDataReducerFailureAction() {
		const state = dataReducer()
		const expected = [{ some: 'failure' }]
		const actual = dataReducer(state, {
			payload: [{ some: 'failure' }],
			type: VALIDATE_USER_FAILURE,
		})
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})
})
