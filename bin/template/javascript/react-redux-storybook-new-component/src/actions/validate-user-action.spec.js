/* eslint-disable prefer-arrow-callback */

// eslint-disable-next-line import/no-unresolved
import asyncTest from 'specs/test-tools/asyncTest'

import {
	setMockApi,
	validateUserRequest,
	validateUserSuccess,
	validateUserFailure,
	validateUser,
} from './validate-user-action'

const suite = 'src/actions/validate-user-action'

describe(suite, function descValidateUserActionSuite() {
	afterEach(function tearDown() {
		setMockApi()
	})

	it('should return a request action', function testValidateUserActionRequest() {
		const expected = {
			payload: { some: 'request payload' },
			type: 'VALIDATE_USER_REQUEST',
		}
		const actual = validateUserRequest({ some: 'request payload' })
		expect(actual).toEqual(expected)
	})

	it('should return a success action', function testValidateUserActionSuccess() {
		const expected = {
			payload: { some: 'success payload' },
			type: 'VALIDATE_USER_SUCCESS',
		}
		const actual = validateUserSuccess({ some: 'success payload' })
		expect(actual).toEqual(expected)
	})

	it('should return a failure action', function testValidateUserActionFailure() {
		const expected = {
			payload: { some: 'failure payload' },
			type: 'VALIDATE_USER_FAILURE',
		}
		const actual = validateUserFailure({ some: 'failure payload' })
		expect(actual).toEqual(expected)
	})

	const testSuccess = 'should invoke api to validate user successfully'
	it(testSuccess, function testValidateUserActionApiSuccess(asyncDone) {
		const spyApi = jest.fn().mockImplementationOnce(() =>
			Promise.resolve({
				data: {
					data: ['THIS IS THE RESPONSE DATA'],
				},
			})
		)
		const spyDispatch = jest.fn()
		setMockApi(spyApi)

		const expectedRequest = {
			payload: { some: 'request payload' },
			type: 'VALIDATE_USER_REQUEST',
		}
		const expectedSuccess = {
			payload: ['THIS IS THE RESPONSE DATA'],
			type: 'VALIDATE_USER_SUCCESS',
		}

		const expectations = asyncTest(
			`${suite} › ${testSuccess}`,
			asyncDone,
			() => {
				expect(spyApi).toHaveBeenCalledTimes(1)
				expect(spyApi).toHaveBeenCalledWith('get', '/validation', null)
				expect(spyDispatch).toHaveBeenCalledTimes(2)
				expect(spyDispatch.mock.calls[0]).toEqual([expectedRequest])
				expect(spyDispatch.mock.calls[1]).toEqual([expectedSuccess])
			}
		)

		const api = validateUser({ some: 'request payload' })
		api(spyDispatch)

		setTimeout(expectations, 100)
	})

	const testFailure = 'should invoke api to validate user with error'
	it(testFailure, function testValidateUserActionApiFailure(asyncDone) {
		const spyApi = jest
			.fn()
			.mockImplementationOnce(() =>
				Promise.reject(new Error('API ERROR REASON'))
			)
		const spyDispatch = jest.fn()
		setMockApi(spyApi)

		const expectedRequest = {
			payload: { some: 'request payload' },
			type: 'VALIDATE_USER_REQUEST',
		}
		const expectedFailure = {
			payload: new Error('API ERROR REASON'),
			type: 'VALIDATE_USER_FAILURE',
		}

		const expectations = asyncTest(
			`${suite} › ${testFailure}`,
			asyncDone,
			() => {
				expect(spyApi).toHaveBeenCalledTimes(1)
				expect(spyApi).toHaveBeenCalledWith('get', '/validation', null)
				expect(spyDispatch).toHaveBeenCalledTimes(2)
				expect(spyDispatch.mock.calls[0]).toEqual([expectedRequest])
				expect(spyDispatch.mock.calls[1]).toEqual([expectedFailure])
			}
		)

		const api = validateUser({ some: 'request payload' })
		api(spyDispatch)

		setTimeout(expectations, 100)
	})
})
