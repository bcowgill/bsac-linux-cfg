import axiosClient from '../utils/axiosUtil'

import {
	VALIDATE_USER_REQUEST,
	VALIDATE_USER_FAILURE,
	VALIDATE_USER_SUCCESS,
} from './types'

let mockApi

export const setMockApi = (mock) => {
	const oldMock = mockApi
	// istanbul ignore next
	if (process.env.NODE_ENV === 'test') {
		mockApi = mock
	}
	return oldMock
}

function api() {
	// istanbul ignore next
	return mockApi || axiosClient
}

export const validateUserRequest = (data) => ({
	type: VALIDATE_USER_REQUEST,
	payload: data,
})

export const validateUserSuccess = (response) => ({
	type: VALIDATE_USER_SUCCESS,
	payload: response,
})

export const validateUserFailure = (error) => ({
	type: VALIDATE_USER_FAILURE,
	payload: error,
})

// '/customer/validation-details'
export const validateUser = (data) => (dispatch) => {
	dispatch(validateUserRequest(data))
	// axios.get('/validation', { headers: { 'Content-Type': 'application/json' } })
	api()('get', '/validation', null)
		.then((response) => dispatch(validateUserSuccess(response.data.data)))
		.catch((error) => dispatch(validateUserFailure(error)))
}
