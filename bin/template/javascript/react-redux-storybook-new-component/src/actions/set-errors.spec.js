/* eslint-disable prefer-arrow-callback */
import { setErrors } from './set-errors'

const suite = 'src/actions/ setErrors Actions'

describe(suite, function descSetErrorsActionSuite() {
	it('should return an errors action with no errors', function testSetErrorsActionNoErrors() {
		const expected = {
			errors: [],
			type: 'SET_ERRORS',
		}
		const actual = setErrors()
		expect(actual).toEqual(expected)
	})

	it('should return an errors action with errors', function testSetErrorsActionErrors() {
		const expected = {
			errors: ['this is an error message', 'this is another error message'],
			type: 'SET_ERRORS',
		}
		const actual = setErrors([
			'this is an error message',
			'this is another error message',
		])
		expect(actual).toEqual(expected)
	})
})
